const express = require('express');
const router = express.Router();
const ApiResponse = require('../../utils/ApiResponse');

const faqs = [
  { id: 1, question: 'How do I book a property?', answer: 'Search for properties, select your dates and guests, then click "Reserve". Follow the checkout steps to confirm your booking.' },
  { id: 2, question: 'Can I cancel my booking?', answer: 'Yes, you can cancel your booking from the Trips section. Cancellation policies vary by property.' },
  { id: 3, question: 'How do I become a host?', answer: 'Go to your Profile and switch to Host mode, then click "List Your Property" to get started.' },
  { id: 4, question: 'What payment methods are accepted?', answer: 'We accept all major credit cards, debit cards, and digital wallets.' },
  { id: 5, question: 'How do I contact a host?', answer: 'Open any property detail page and click "Contact Host" to start a conversation.' },
  { id: 6, question: 'What if I have an issue during my stay?', answer: 'You can reach out to the host directly through the messaging system or contact our support team.' },
  { id: 7, question: 'How are reviews handled?', answer: 'After your stay is completed, you can leave a review for the property. Reviews help maintain quality for all guests.' },
  { id: 8, question: 'Can I save properties for later?', answer: 'Yes! Tap the heart icon on any property to add it to your Wishlists.' },
];

router.get('/faqs', (req, res) => {
  return ApiResponse.success(res, 'FAQs fetched successfully', { faqs });
});

router.get('/contact', (req, res) => {
  return ApiResponse.success(res, 'Contact info fetched successfully', {
    email: 'support@goanest.com',
    phone: '+1-800-GOANEST',
    availableHours: '24/7',
  });
});

module.exports = router;
