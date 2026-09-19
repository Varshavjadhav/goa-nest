# Airbnb-Like App – Booking, Availability & Payment Flow

Functional flow and backend implementation guide.

---

## 1. Complete User Flow

```text
Home
  ↓
Search
  ↓
Search Results
  ↓
Property / Hotel Detail
  ↓
Select Check-in + Check-out + Guests
  ↓
Check Availability
  ↓
Price Calculation
  ↓
Reserve / Request to Book
  ↓
Temporary Booking Hold
  ↓
Checkout
  ↓
Payment
  ↓
Backend Payment Verification
  ↓
Booking Confirmed
  ↓
My Trips / Booking Details
  ↓
Check-in
  ↓
Checkout
  ↓
Review
```

---

## 2. Property Detail Screen

Show:

- Property images
- Property/hotel title
- Location
- Rating
- Amenities
- Guest capacity
- Pricing
- Cancellation policy
- Primary booking action

Initially, the primary button can be:

```text
[ Check availability ]
```

Example:

```text
Property: Beautiful Villa
Location: Pune
Guests: 4
Price: ₹4,500/night

[ Check availability ]
```

After valid dates and guest count are selected and availability is confirmed, show:

```text
[ Reserve ]
```

or:

```text
[ Request to Book ]
```

depending on the property's booking mode.

---

## 3. Date & Guest Selection

User selects:

- Check-in date
- Check-out date
- Number of guests
- Number of rooms, if applicable

Validate:

- Check-out must be after check-in.
- Dates must not be in the past.
- Guests must not exceed property capacity.
- Rooms must not exceed available inventory.

Example API:

```http
POST /availability/check
```

Request:

```json
{
  "propertyId": "123",
  "checkIn": "2026-09-25",
  "checkOut": "2026-09-28",
  "guests": 2,
  "rooms": 1
}
```

---

## 4. Availability Check

Backend should check:

1. Property is active.
2. Dates are valid.
3. Guest capacity is valid.
4. Existing confirmed bookings.
5. Active temporary holds.
6. Host-blocked/unavailable dates.
7. Room/inventory count.
8. Current price.

Availability must be checked on the backend.

### Available

```text
Available
    ↓
Calculate price
    ↓
Show booking summary
```

### Unavailable

```text
Not available for these dates

[ Change dates ]
[ View similar properties ]
```

Do not continue to payment if the requested inventory is unavailable.

---

## 5. Reserve vs Request to Book

### Instant Booking

If:

```text
instantBooking = true
```

Flow:

```text
Property Detail
    ↓
Check Availability
    ↓
Reserve
    ↓
Checkout
    ↓
Payment
    ↓
Confirmed
```

No host approval is required after the required booking/payment checks.

### Request to Book

If:

```text
instantBooking = false
```

Flow:

```text
Property Detail
    ↓
Check Availability
    ↓
Request to Book
    ↓
Checkout / payment handling
    ↓
Pending host response
    ↓
Host Accepts
    ↓
Confirmed
```

If the host rejects or the request expires:

```text
Request
    ↓
Rejected / Expired
    ↓
Release inventory
    ↓
Refund if applicable
```

---

## 6. Temporary Inventory Hold – Critical

When the user starts checkout, create a temporary hold.

This prevents another user from booking the same inventory while the first user is paying.

Example:

```text
User A
  ↓
Check availability
  ↓
Create temporary hold
  ↓
10-minute timer
  ↓
Payment
  ↓
Booking confirmed
```

Database example:

```text
bookingStatus = PAYMENT_PENDING
holdExpiresAt = <timestamp>
```

### Payment success

```text
PAYMENT_PENDING
        ↓
CONFIRMED
```

### Payment failure / timeout

```text
PAYMENT_PENDING
        ↓
EXPIRED
        ↓
Release inventory
```

The exact hold duration can be configured for your application.

---

## 7. Booking Summary / Checkout

Example:

```text
Property / Hotel

Check-in: Sep 25
Check-out: Sep 28
Guests: 2

₹4,500 × 3 nights       ₹13,500
Cleaning fee                ₹500
Service fee                 ₹700
Taxes                       ₹936
Discount                    -₹0
--------------------------------
Total                    ₹15,636

Payment method:

○ UPI
○ Card
○ Net Banking
○ Wallet

[ Pay ₹15,636 ]
```

### Important

The backend must calculate the final amount.

Do not trust a total amount sent from Flutter.

Flutter should send:

```json
{
  "propertyId": "123",
  "checkIn": "2026-09-25",
  "checkOut": "2026-09-28",
  "guests": 2,
  "rooms": 1
}
```

Backend calculates:

```text
Nightly price
+ Cleaning fee
+ Service fee
+ Tax
- Discount
= Final amount
```

Then return the server-calculated amount.

---

## 8. Booking Creation API

Example:

```http
POST /bookings/hold
```

Request:

```json
{
  "propertyId": "123",
  "checkIn": "2026-09-25",
  "checkOut": "2026-09-28",
  "guests": 2,
  "rooms": 1
}
```

Backend:

```text
1. Re-check availability
2. Calculate price
3. Lock inventory temporarily
4. Create booking
5. Create/prepare payment order
6. Return bookingId + payment information
```

---

## 9. Payment Flow

Recommended architecture:

```text
Flutter
  ↓
Create booking / payment request
  ↓
Backend creates payment order
  ↓
Payment Gateway
  ↓
User completes payment
  ↓
Gateway sends result/webhook
  ↓
Backend verifies transaction
  ↓
Backend updates payment status
  ↓
Backend confirms booking
  ↓
Flutter fetches booking status
  ↓
Show Booking Confirmed
```

Possible gateways for an India-focused application include:

- Razorpay
- PhonePe
- Cashfree
- PayU
- Stripe

The final gateway should depend on your business requirements.

### Critical payment rule

Do not do:

```text
Flutter says payment successful
        ↓
Booking confirmed
```

Instead:

```text
Payment result
        ↓
Gateway webhook
        ↓
Backend verification
        ↓
Payment SUCCESS
        ↓
Booking CONFIRMED
```

---

## 10. Booking and Payment Status

### Booking Status

| Status | Meaning |
|---|---|
| `PENDING` | Booking/request created but not completed |
| `PAYMENT_PENDING` | Inventory held while payment is being completed |
| `CONFIRMED` | Booking successfully confirmed |
| `REJECTED` | Host rejected a request |
| `CANCELLED` | Booking cancelled |
| `COMPLETED` | Stay/trip completed |
| `EXPIRED` | Temporary hold or request expired |

### Payment Status

| Status | Meaning |
|---|---|
| `PENDING` | Payment not completed |
| `PROCESSING` | Gateway is processing |
| `SUCCESS` | Payment verified successfully |
| `FAILED` | Payment failed |
| `REFUNDED` | Full refund completed |
| `PARTIALLY_REFUNDED` | Partial refund completed |

Keep `bookingStatus` and `paymentStatus` separate.

---

## 11. Booking Database Structure

```text
Booking
--------
id
userId
propertyId
hostId

checkIn
checkOut
guests
rooms

nightlyAmount
cleaningFee
serviceFee
tax
discount
totalAmount

bookingStatus
paymentStatus

paymentOrderId
paymentId
transactionId

bookingType
cancellationPolicy

holdExpiresAt
createdAt
confirmedAt
cancelledAt
```

---

## 12. My Trips / Booking Details

My Trips can contain:

```text
Upcoming
Ongoing
Completed
Cancelled
```

Example:

```text
My Trips

┌──────────────────────┐
│ Villa A              │
│ Pune                 │
│ Sep 25 - Sep 28      │
│ 2 Guests             │
│                      │
│ CONFIRMED            │
│                      │
│ [ View details ]     │
└──────────────────────┘
```

Booking details:

```text
Villa A

Sep 25 - Sep 28
2 guests

Payment
₹20,060
Paid

Booking ID
BK123456

Cancellation
Free cancellation until Sep 22

[ Message Host ]
[ Get Directions ]
[ Cancel booking ]
```

---

## 13. Cancellation & Refund Flow

```text
User taps Cancel Booking
        ↓
Backend checks cancellation policy
        ↓
Calculate refund
        ↓
Booking → CANCELLED
        ↓
Inventory released
        ↓
Refund request sent to payment gateway
        ↓
Refund status tracked
        ↓
REFUNDED / PARTIALLY_REFUNDED
```

Example cancellation policy:

```text
Free cancellation until 7 days before check-in

50% refund:
3–7 days before check-in

No refund:
Less than 3 days before check-in
```

These are example rules; configure your actual business policy separately.

### Important

Store the cancellation policy used for each booking.

This prevents a later policy change from changing the rules of an existing booking.

---

## 14. Host Flow

Host dashboard:

```text
Host Dashboard
      ↓
Properties
      ↓
Calendar / Availability
      ↓
Bookings
```

### Instant Booking

```text
Guest books
    ↓
Payment verified
    ↓
Booking confirmed
    ↓
Host sees confirmed booking
```

### Request to Book

```text
New request

Villa A
Sep 25 - Sep 28
2 Guests
₹20,060

[ Accept ]
[ Decline ]
```

Accept:

```text
REQUESTED
    ↓
ACCEPTED
    ↓
CONFIRMED
```

Decline:

```text
REQUESTED
    ↓
REJECTED
    ↓
Release inventory
    ↓
Refund if applicable
```

---

## 15. Calendar / Inventory Management

Host should be able to:

- Block dates manually.
- View confirmed bookings.
- View temporary holds.
- Open dates.
- Change availability.
- Manage room inventory.

For a single property:

```text
Sep 25 → BOOKED
Sep 26 → BOOKED
Sep 27 → BOOKED
Sep 28 → AVAILABLE
```

For multiple hotel rooms, maintain inventory count.

Example:

```text
Total rooms = 10

Sep 25:
Confirmed = 6
Held = 1
Available = 3
```

A booking for 1 room is allowed.

A booking for 4 rooms is rejected.

---

## 16. Recommended API List

| Method | API | Purpose |
|---|---|---|
| GET | `/properties/:id` | Property details |
| POST | `/availability/check` | Check dates, guests and inventory |
| POST | `/bookings/hold` | Create temporary inventory hold |
| POST | `/bookings` | Create/submit booking |
| POST | `/payments/create-order` | Create payment order |
| POST | `/payments/verify` | Server-side payment verification |
| POST | `/payments/webhook` | Receive payment gateway webhook |
| GET | `/bookings` | User booking list |
| GET | `/bookings/:id` | Booking details |
| POST | `/bookings/:id/cancel` | Cancel booking |
| POST | `/bookings/:id/refund` | Process/track refund |
| GET | `/properties/:id/calendar` | Availability calendar |
| POST | `/properties/:id/block-dates` | Host blocks dates |

---

## 17. Flutter Screen Flow

```text
PropertyDetailScreen
        ↓
DateGuestSelectionScreen
        ↓
Availability API
        ↓
BookingSummaryScreen
        ↓
CreateBooking / Hold API
        ↓
PaymentScreen
        ↓
PaymentGateway SDK
        ↓
BookingStatus / Verification API
        ↓
BookingConfirmationScreen
        ↓
MyTripsScreen
        ↓
BookingDetailScreen
```

---

## 18. Recommended Flutter State Handling

Keep availability, booking and payment states separate.

### Availability states

```text
Checking availability
Available
Unavailable
```

### Booking states

```text
Creating booking
Pending
Confirmed
Rejected
Cancelled
Expired
```

### Payment states

```text
Payment pending
Payment processing
Payment success
Payment failed
Refund pending
Refunded
```

After returning from the payment gateway, fetch booking status from the backend.

If the app is closed during payment, the backend should still be able to resolve the booking using `bookingId`.

Never rely only on local Flutter state for final booking confirmation.

---

## 19. Complete End-to-End Example

Suppose:

```text
Property = Villa A
Price = ₹5,000/night

Check-in  = Sep 25
Check-out = Sep 28

3 nights
Guests = 2
```

Price:

```text
Room          ₹15,000
Cleaning      ₹1,000
Service       ₹1,000
Tax           ₹3,060
--------------------
Total         ₹20,060
```

Flow:

```text
1. User selects dates and guests.
2. Flutter calls /availability/check.
3. Backend confirms dates are available.
4. Backend calculates ₹20,060.
5. User taps Reserve.
6. Backend re-checks availability.
7. Backend creates a temporary hold.
8. Backend creates payment order.
9. Flutter opens payment gateway.
10. User pays ₹20,060.
11. Payment gateway sends webhook.
12. Backend verifies payment.
13. paymentStatus = SUCCESS.
14. bookingStatus = CONFIRMED.
15. Inventory becomes booked.
16. Flutter fetches booking status.
17. Confirmation screen is displayed.
18. Booking appears in My Trips.
```

---

## 20. Critical Rules

1. Always check availability on the backend.
2. Re-check availability immediately before confirming a booking.
3. Use a temporary hold during checkout/payment.
4. Never trust a client-provided final amount.
5. Verify payment on the backend.
6. Use payment gateway webhooks where supported.
7. Keep `bookingStatus` and `paymentStatus` separate.
8. Release inventory after payment failure or hold expiry.
9. Apply cancellation/refund rules on the backend.
10. Store the cancellation policy used for each booking.
11. Make booking confirmation idempotent so duplicate payment callbacks do not create duplicate bookings.
12. Use server-generated booking IDs and payment order IDs.
13. Do not expose secret payment gateway credentials in Flutter.
14. Keep payment and booking records auditable.

---

## 21. Final Architecture

```text
                  ┌───────────────────┐
                  │ Property Detail   │
                  └─────────┬─────────┘
                            ↓
                  ┌───────────────────┐
                  │ Dates + Guests    │
                  └─────────┬─────────┘
                            ↓
                  ┌───────────────────┐
                  │ Availability API  │
                  └───────┬─────┬─────┘
                          │     │
                    Available   │
                          │     └── Unavailable
                          ↓
                  ┌───────────────────┐
                  │ Booking Hold      │
                  └─────────┬─────────┘
                            ↓
                  ┌───────────────────┐
                  │ Checkout          │
                  └─────────┬─────────┘
                            ↓
                  ┌───────────────────┐
                  │ Payment Gateway   │
                  └─────────┬─────────┘
                            ↓
                  ┌───────────────────┐
                  │ Backend Verify    │
                  └─────────┬─────────┘
                            ↓
                  ┌───────────────────┐
                  │ Booking Confirmed │
                  └─────────┬─────────┘
                            ↓
                  ┌───────────────────┐
                  │ My Trips          │
                  └─────────┬─────────┘
                            ↓
                  ┌───────────────────┐
                  │ Stay + Review     │
                  └───────────────────┘
```

---

## 22. Implementation Priority

Implement in this order:

1. Property detail + date/guest selection
2. Availability API + calendar/inventory
3. Price calculation
4. Temporary booking hold
5. Booking creation
6. Payment gateway integration
7. Webhook + payment verification
8. Booking confirmation
9. My Trips + booking details
10. Cancellation + refund
11. Host calendar + booking management
12. Notifications, check-in and reviews

---

## 23. Important Business Logic Summary

The core rule is:

```text
DETAIL
  ↓
SELECT DATES + GUESTS
  ↓
CHECK AVAILABILITY
  ↓
CALCULATE PRICE
  ↓
CREATE TEMPORARY HOLD
  ↓
CHECKOUT
  ↓
PAYMENT
  ↓
BACKEND PAYMENT VERIFICATION
  ↓
CONFIRM BOOKING
  ↓
BLOCK INVENTORY
  ↓
MY TRIPS
```

The backend is the source of truth for:

- Availability
- Price
- Booking status
- Payment status
- Cancellation
- Refund
- Inventory
- Final booking confirmation

> This document describes an Airbnb-like architecture for your own rental/hotel application. Exact payment, cancellation, tax, invoicing, KYC, and marketplace payout requirements should be configured according to your business model and applicable local rules.
