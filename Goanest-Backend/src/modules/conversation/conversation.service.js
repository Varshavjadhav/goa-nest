const Conversation = require('./conversation.model');
const Message = require('./message.model');
const ApiError = require('../../utils/ApiError');
const { MESSAGES } = require('../../config/constants');

const getConversations = async (userId) => {
  const conversations = await Conversation.find({ participants: userId })
    .populate('participants', 'name avatar')
    .populate('property', 'title images')
    .populate('lastMessageBy', 'name')
    .sort({ lastMessageAt: -1, createdAt: -1 });
  return conversations;
};

const getConversationById = async (conversationId, userId) => {
  const conversation = await Conversation.findById(conversationId)
    .populate('participants', 'name avatar')
    .populate('property', 'title images location');

  if (!conversation) {
    throw ApiError.notFound(MESSAGES.CONVERSATION_NOT_FOUND);
  }

  if (!conversation.participants.some((p) => p._id.toString() === userId)) {
    throw ApiError.forbidden(MESSAGES.FORBIDDEN);
  }

  return conversation;
};

const createConversation = async (senderId, data) => {
  const { recipientId, propertyId, bookingId, message } = data;

  const existing = await Conversation.findOne({
    participants: { $all: [senderId, recipientId] },
    ...(propertyId && { property: propertyId }),
  });

  if (existing) {
    if (message) {
      const msg = await Message.create({
        conversation: existing._id,
        sender: senderId,
        content: message,
      });
      existing.lastMessage = message;
      existing.lastMessageAt = new Date();
      existing.lastMessageBy = senderId;
      const unread = existing.unreadCount || {};
      unread[recipientId] = (unread[recipientId] || 0) + 1;
      existing.unreadCount = unread;
      await existing.save();
    }
    return existing.populate('participants', 'name avatar');
  }

  const conversation = await Conversation.create({
    participants: [senderId, recipientId],
    property: propertyId || null,
    booking: bookingId || null,
    lastMessage: message || null,
    lastMessageAt: message ? new Date() : null,
    lastMessageBy: message ? senderId : null,
    unreadCount: message ? { [recipientId]: 1 } : {},
  });

  if (message) {
    await Message.create({
      conversation: conversation._id,
      sender: senderId,
      content: message,
    });
  }

  return conversation.populate('participants', 'name avatar');
};

const sendMessage = async (conversationId, senderId, content) => {
  const conversation = await Conversation.findById(conversationId);
  if (!conversation) {
    throw ApiError.notFound(MESSAGES.CONVERSATION_NOT_FOUND);
  }

  if (!conversation.participants.some((p) => p.toString() === senderId)) {
    throw ApiError.forbidden(MESSAGES.FORBIDDEN);
  }

  const message = await Message.create({
    conversation: conversationId,
    sender: senderId,
    content,
  });

  conversation.lastMessage = content;
  conversation.lastMessageAt = new Date();
  conversation.lastMessageBy = senderId;

  const unread = conversation.unreadCount || {};
  conversation.participants.forEach((p) => {
    if (p.toString() !== senderId) {
      unread[p.toString()] = (unread[p.toString()] || 0) + 1;
    }
  });
  conversation.unreadCount = unread;
  await conversation.save();

  return message.populate('sender', 'name avatar');
};

const getMessages = async (conversationId, userId, page = 1, limit = 50) => {
  const conversation = await Conversation.findById(conversationId);
  if (!conversation) {
    throw ApiError.notFound(MESSAGES.CONVERSATION_NOT_FOUND);
  }

  if (!conversation.participants.some((p) => p.toString() === userId)) {
    throw ApiError.forbidden(MESSAGES.FORBIDDEN);
  }

  const skip = (page - 1) * limit;
  const [messages, total] = await Promise.all([
    Message.find({ conversation: conversationId })
      .populate('sender', 'name avatar')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit),
    Message.countDocuments({ conversation: conversationId }),
  ]);

  return { messages: messages.reverse(), total, page, pages: Math.ceil(total / limit) };
};

const markAsRead = async (conversationId, userId) => {
  const conversation = await Conversation.findById(conversationId);
  if (!conversation) {
    throw ApiError.notFound(MESSAGES.CONVERSATION_NOT_FOUND);
  }

  const unread = conversation.unreadCount || {};
  unread[userId] = 0;
  conversation.unreadCount = unread;
  await conversation.save();

  await Message.updateMany(
    { conversation: conversationId, sender: { $ne: userId }, readAt: null },
    { readAt: new Date() }
  );

  return true;
};

module.exports = {
  getConversations,
  getConversationById,
  createConversation,
  sendMessage,
  getMessages,
  markAsRead,
};
