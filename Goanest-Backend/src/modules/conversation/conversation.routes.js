const express = require('express');
const router = express.Router();
const conversationController = require('./conversation.controller');
const { auth } = require('../../middlewares/auth');

router.get('/', auth, conversationController.getConversations);
router.post('/', auth, conversationController.createConversation);
router.get('/:id', auth, conversationController.getConversation);
router.post('/:id/messages', auth, conversationController.sendMessage);
router.get('/:id/messages', auth, conversationController.getMessages);
router.put('/:id/read', auth, conversationController.markAsRead);

module.exports = router;
