# Goanest API Documentation

**Base URL:** `http://localhost:5000/api/v1`

**Authentication:** Bearer token in `Authorization` header
```
Authorization: Bearer <access_token>
```

**Response Format:**
```json
{
  "success": true,
  "message": "Success",
  "data": { ... }
}
```

**Error Format:**
```json
{
  "success": false,
  "message": "Error message"
}
```

---

## 1. Authentication

### POST /auth/register
Register a new user.

**Request:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1-555-0100",
  "password": "password123"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "_id": "...",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "+1-555-0100",
      "role": "user",
      "createdAt": "..."
    },
    "accessToken": "...",
    "refreshToken": "..."
  }
}
```

### POST /auth/login
Login with email and password.

**Request:**
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": { ... },
    "accessToken": "...",
    "refreshToken": "..."
  }
}
```

### POST /auth/refresh-token
Refresh access token.

**Request:**
```json
{
  "refreshToken": "..."
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Token refreshed successfully",
  "data": {
    "accessToken": "...",
    "refreshToken": "..."
  }
}
```

### POST /auth/logout
Logout (requires auth).

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

## 2. User

### GET /user/profile
Get current user profile.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "message": "Profile fetched successfully",
  "data": {
    "user": {
      "_id": "...",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "+1-555-0100",
      "avatar": "https://...",
      "bio": "Travel enthusiast",
      "role": "user",
      "location": "New York",
      "language": "en",
      "currency": "USD",
      "createdAt": "..."
    }
  }
}
```

### PUT /user/profile
Update user profile.

**Headers:** `Authorization: Bearer <token>`

**Request:**
```json
{
  "name": "John Updated",
  "phone": "+1-555-0101",
  "bio": "Updated bio",
  "avatar": "https://new-avatar.jpg",
  "location": "San Francisco",
  "language": "en",
  "currency": "USD"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "user": { ... }
  }
}
```

---

## 3. Categories

### GET /categories
Get all active categories.

**Response (200):**
```json
{
  "success": true,
  "message": "Categories fetched successfully",
  "data": {
    "categories": [
      {
        "_id": "...",
        "name": "Trending",
        "slug": "trending",
        "icon": "🔥",
        "description": "Most popular properties right now"
      }
    ]
  }
}
```

---

## 4. Properties

### GET /home
Returns the screen-ready Home response used by the Flutter app. Send a bearer token to include `isLiked` state and personalized recently viewed items.

Optional query: `tab=all|homes|villas|beach|experiences|services`.

The response contains `search`, `tabs`, `continueSearching`, `recentlyViewed`, `recommendedForYou`, `popularDestinationStays`, `guestFavourites`, `tripInspiration`, `exploreMore`, and `experiences`. `/explore` returns the same contract for backwards compatibility.

### GET /explore
Returns the response mapped to the Stitch Explore screen. It contains `search`, `tabs`, `continueSearching`, `recentlyViewed`, `recommendedForYou`, `popularDestinationStays`, `guestFavourites`, `tripInspiration`, `exploreMore`, and `experiences`. Send a bearer token to populate personalized recently viewed and liked state.

### POST /favorites/:propertyId
Like a property. Requires authentication. The operation is idempotent.

### DELETE /favorites/:propertyId
Unlike a property. Requires authentication. The operation is idempotent.

### GET /recently-viewed
Get the authenticated user’s complete recently viewed list.

Query parameters: `page` (default `1`) and `limit` (default `20`, maximum `100`).

### POST /recently-viewed/:propertyId
Record a property view. Property detail requests record this automatically for authenticated users.

### GET /properties
Get all properties with filters.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| page | number | Page number (default: 1) |
| limit | number | Items per page (default: 20) |
| city | string | Filter by city |
| country | string | Filter by country |
| propertyType | string | Filter by type (apartment/house/villa/etc) |
| category | string | Category ID |
| minPrice | number | Minimum price per night |
| maxPrice | number | Maximum price per night |
| maxGuests | number | Minimum guests capacity |
| bedrooms | number | Minimum bedrooms |
| amenities | string | Comma-separated amenities |
| minRating | number | Minimum average rating |
| sort | string | Sort option |
| tab | string | Home chip: all/homes/villas/beach/experiences/services |

**Response (200):**
```json
{
  "success": true,
  "message": "Properties fetched successfully",
  "data": {
    "properties": [
      {
        "_id": "...",
        "title": "Luxury Beach Villa",
        "description": "...",
        "propertyType": "villa",
        "host": { "_id": "...", "name": "Host Name", "avatar": "..." },
        "category": { "_id": "...", "name": "Beachfront", "slug": "beachfront", "icon": "🏖️" },
        "location": {
          "address": "123 Ocean Drive",
          "city": "Miami",
          "state": "Florida",
          "country": "USA",
          "lat": 25.7907,
          "lng": -80.13
        },
        "pricePerNight": 450,
        "maxGuests": 8,
        "bedrooms": 4,
        "beds": 5,
        "bathrooms": 3,
        "amenities": ["Wifi", "Pool", "Kitchen"],
        "images": [{ "url": "https://...", "isPrimary": true }],
        "averageRating": 4.9,
        "totalReviews": 127,
        "isFeatured": true
      }
    ],
    "total": 50,
    "page": 1,
    "pages": 3
  }
}
```

### GET /properties/featured
Get featured properties.

**Query:** `limit` (default: 10)

**Response:** Same as GET /properties with featured only.

### POST /availability/check
Check dates, guest capacity, booking type, and calculated price details for a property.

**Request:**
```json
{
  "propertyId": "...",
  "checkIn": "2026-10-12",
  "checkOut": "2026-10-15",
  "guests": 2,
  "rooms": 1
}
```

The response includes `available`, `bookingType`, `nights`, `nightlyAmount`, `cleaningFee`, `serviceFee`, `tax`, `discount`, and `totalAmount`.

### GET /properties/:id
Get single property details.

**Response (200):**
```json
{
  "success": true,
  "message": "Property fetched successfully",
  "data": {
    "property": {
      "_id": "...",
      "title": "Luxury Beach Villa",
      "description": "...",
      "propertyType": "villa",
      "host": { "_id": "...", "name": "Host Name", "avatar": "...", "bio": "..." },
      "category": { ... },
      "location": { ... },
      "pricePerNight": 450,
      "maxGuests": 8,
      "bedrooms": 4,
      "beds": 5,
      "bathrooms": 3,
      "amenities": [...],
      "images": [...],
      "houseRules": "...",
      "checkInTime": "15:00",
      "checkOutTime": "11:00",
      "minimumNights": 2,
      "averageRating": 4.9,
      "totalReviews": 127
    }
  }
}
```

### GET /properties/:id/availability
Check property availability.

**Query:** `checkIn` (ISO date), `checkOut` (ISO date)

**Response (200):**
```json
{
  "success": true,
  "message": "Availability checked successfully",
  "data": {
    "available": true,
    "property": {
      "id": "...",
      "pricePerNight": 450,
      "minimumNights": 2,
      "maximumNights": 365
    }
  }
}
```

### POST /properties
Create a new property (Host only).

**Headers:** `Authorization: Bearer <host_token>`

**Request:**
```json
{
  "title": "Beautiful Beach House",
  "description": "Amazing beach house with ocean views...",
  "propertyType": "house",
  "location": {
    "address": "456 Beach Road",
    "city": "Malibu",
    "state": "California",
    "country": "USA",
    "lat": 34.0259,
    "lng": -118.7798
  },
  "pricePerNight": 350,
  "maxGuests": 6,
  "bedrooms": 3,
  "beds": 4,
  "bathrooms": 2,
  "amenities": ["Wifi", "Pool", "Kitchen", "Beach access"],
  "images": [
    { "url": "https://...", "isPrimary": true }
  ],
  "category": "category_id_here",
  "checkInTime": "15:00",
  "checkOutTime": "11:00",
  "minimumNights": 2
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Property created successfully",
  "data": {
    "property": { ... }
  }
}
```

### PUT /properties/:id
Update a property (Host only, must be owner).

### DELETE /properties/:id
Delete a property (Host only, must be owner).

### GET /properties/my-properties
Get host's properties.

---

## 5. Search

### GET /search
Full search with filters.

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| query | string | Free text search |
| city | string | City filter |
| country | string | Country filter |
| propertyType | string | Property type |
| category | string | Category ID |
| minPrice | number | Min price |
| maxPrice | number | Max price |
| maxGuests | number | Min guest capacity |
| bedrooms | number | Min bedrooms |
| beds | number | Min beds |
| bathrooms | number | Min bathrooms |
| amenities | string | Comma-separated |
| minRating | number | Min rating |
| checkIn | ISO date | Check-in date |
| checkOut | ISO date | Check-out date (excludes booked properties) |
| sortBy | string | price_asc, price_desc, rating, newest |
| tab | string | all, homes, villas, beach, experiences, services |
| page | number | Page number |
| limit | number | Per page |

**Response:** Same as GET /properties

### GET /search/suggestions
Get search suggestions.

**Query:** `q` (search term, min 2 chars)

**Response (200):**
```json
{
  "success": true,
  "message": "Suggestions fetched successfully",
  "data": {
    "suggestions": [
      { "city": "Miami", "country": "USA", "propertyCount": 12 }
    ]
  }
}
```

---

## 6. Bookings

### POST /bookings
Create a booking.

**Headers:** `Authorization: Bearer <token>`

**Request:**
```json
{
  "property": "property_id",
  "checkIn": "2026-09-15",
  "checkOut": "2026-09-20",
  "guests": {
    "adults": 2,
    "children": 1,
    "infants": 0
  },
  "specialRequests": "Late check-in please"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Booking created successfully",
  "data": {
    "booking": {
      "_id": "...",
      "property": { "title": "...", "images": [...], "location": {...} },
      "guest": { "name": "...", "email": "...", "avatar": "..." },
      "checkIn": "2026-09-15T00:00:00.000Z",
      "checkOut": "2026-09-20T00:00:00.000Z",
      "guests": { "adults": 2, "children": 1, "infants": 0 },
      "nights": 5,
      "pricePerNight": 450,
      "totalPrice": 2250,
      "cleaningFee": 113,
      "serviceFee": 315,
      "status": "confirmed"
    }
  }
}
```

### GET /bookings
Get user's bookings.

**Query:** `status` (pending/confirmed/cancelled/completed), `page`, `limit`

**Response (200):**
```json
{
  "success": true,
  "message": "Bookings fetched successfully",
  "data": {
    "bookings": [...],
    "total": 5,
    "page": 1,
    "pages": 1
  }
}
```

### GET /bookings/:id
Get booking details.

### PUT /bookings/:id/cancel
Cancel a booking.

**Request:**
```json
{
  "reason": "Change of plans"
}
```

---

## 7. Reviews

### GET /reviews/:propertyId
Get reviews for a property.

**Query:** `page`, `limit`

**Response (200):**
```json
{
  "success": true,
  "message": "Reviews fetched successfully",
  "data": {
    "reviews": [
      {
        "_id": "...",
        "guest": { "name": "John", "avatar": "..." },
        "rating": 5,
        "comment": "Amazing stay!",
        "cleanliness": 5,
        "accuracy": 5,
        "communication": 5,
        "location": 5,
        "checkIn": 5,
        "value": 5,
        "createdAt": "..."
      }
    ],
    "total": 10,
    "page": 1,
    "pages": 1
  }
}
```

### POST /reviews/:propertyId
Submit a review.

**Headers:** `Authorization: Bearer <token>`

**Request:**
```json
{
  "booking": "booking_id",
  "rating": 5,
  "comment": "Wonderful property!",
  "cleanliness": 5,
  "accuracy": 5,
  "communication": 5,
  "location": 5,
  "checkIn": 5,
  "value": 5
}
```

---

## 8. Wishlists

### GET /wishlists
Get user's wishlists.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "message": "Wishlists fetched successfully",
  "data": {
    "wishlists": [
      {
        "_id": "...",
        "name": "Favorites",
        "properties": [
          {
            "property": { "_id": "...", "title": "...", "images": [...], "pricePerNight": 450, "location": {...}, "averageRating": 4.9 },
            "addedAt": "..."
          }
        ]
      }
    ]
  }
}
```

### POST /wishlists
Create a new wishlist.

**Request:**
```json
{ "name": "Beach Getaways" }
```

### PUT /wishlists/:id
Update wishlist name.

### DELETE /wishlists/:id
Delete a wishlist.

### POST /wishlists/:id/properties/:propertyId
Add property to wishlist.

### DELETE /wishlists/:id/properties/:propertyId
Remove property from wishlist.

---

## 9. Conversations & Messages

### GET /conversations
Get user's conversations.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "message": "Conversations fetched successfully",
  "data": {
    "conversations": [
      {
        "_id": "...",
        "participants": [{ "name": "...", "avatar": "..." }],
        "property": { "title": "...", "images": [...] },
        "lastMessage": "Thanks for reaching out!",
        "lastMessageAt": "...",
        "unreadCount": { "user_id": 2 }
      }
    ]
  }
}
```

### POST /conversations
Start a new conversation.

**Request:**
```json
{
  "recipientId": "host_user_id",
  "propertyId": "property_id (optional)",
  "bookingId": "booking_id (optional)",
  "message": "Hi, I'm interested in your property!"
}
```

### GET /conversations/:id
Get conversation details.

### GET /conversations/:id/messages
Get messages in a conversation.

**Query:** `page`, `limit`

### POST /conversations/:id/messages
Send a message.

**Request:**
```json
{ "content": "Hello! Is this property available?" }
```

### PUT /conversations/:id/read
Mark conversation as read.

---

## 10. Help

### GET /help/faqs
Get frequently asked questions.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "faqs": [
      { "id": 1, "question": "How do I book a property?", "answer": "..." }
    ]
  }
}
```

### GET /help/contact
Get contact information.

---

## Error Codes

| Code | Description |
|------|-------------|
| 400 | Bad Request - Invalid input |
| 401 | Unauthorized - Invalid/missing token |
| 403 | Forbidden - No permission |
| 404 | Not Found - Resource doesn't exist |
| 409 | Conflict - Resource already exists |
| 500 | Internal Server Error |

## Property Types
`apartment`, `house`, `hotel`, `villa`, `cottage`, `cabin`, `treehouse`, `castle`, `tent`, `other`

## Booking Statuses
`pending`, `confirmed`, `cancelled`, `completed`

## User Roles
`user` (guest), `host`, `admin`
