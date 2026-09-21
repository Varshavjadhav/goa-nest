const conversationService = require('./conversation.service');
const ApiResponse = require('../../utils/ApiResponse');
const { MESSAGES } = require('../../config/constants');
const asyncHandler = require('../../utils/asyncHandler');

const getConversations = asyncHandler(async (req, res) => {
  const conversations = await conversationService.getConversations(req.user);
  return ApiResponse.success(res, MESSAGES.CONVERSATIONS_FETCHED, { conversations });
});

const getConversation = asyncHandler(async (req, res) => {
  const conversation = await conversationService.getConversationById(req.params.id, req.user);
  return ApiResponse.success(res, 'Conversation fetched successfully', { conversation });
});

const createConversation = asyncHandler(async (req, res) => {
  const conversation = await conversationService.createConversation(req.user, req.body);
  return ApiResponse.success(res, MESSAGES.CONVERSATION_CREATED, { conversation }, 201);
});

const sendMessage = asyncHandler(async (req, res) => {
  const message = await conversationService.sendMessage(req.params.id, req.user, req.body.content);
  return ApiResponse.success(res, MESSAGES.MESSAGE_SENT, { message }, 201);
});

const getMessages = asyncHandler(async (req, res) => {
  const { page, limit } = req.query;
  const result = await conversationService.getMessages(req.params.id, req.user, page, limit);
  return ApiResponse.success(res, MESSAGES.MESSAGES_FETCHED, result);
});

const markAsRead = asyncHandler(async (req, res) => {
  await conversationService.markAsRead(req.params.id, req.user);
  return ApiResponse.success(res, 'Marked as read');
});

module.exports = {
  getConversations,
  getConversation,
  createConversation,
  sendMessage,
  getMessages,
  markAsRead,
};
