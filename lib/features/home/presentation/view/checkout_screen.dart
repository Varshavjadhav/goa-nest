import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goanest/app/router/route_name.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int paymentMethod = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: AppBar(
        backgroundColor: const Color(0xfffafafa),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, size: 20),
        ),
        title: const Text(
          'Confirm and pay',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _StayCard(),
            const SizedBox(height: 26),
            const _SectionTitle('Your trip'),
            const SizedBox(height: 14),
            const _TripRow(
              icon: Icons.calendar_month_outlined,
              title: 'Dates',
              value: 'Aug 28 – Sep 1, 2026',
            ),
            const _TripRow(
              icon: Icons.group_outlined,
              title: 'Guests',
              value: '2 guests',
            ),
            const Divider(height: 35),
            const _SectionTitle('Payment method'),
            const SizedBox(height: 12),
            _PaymentOption(
              icon: Icons.credit_card,
              title: 'Credit or debit card',
              subtitle: 'Visa, Mastercard, RuPay',
              selected: paymentMethod == 0,
              onTap: () => setState(() => paymentMethod = 0),
              child: const _CardFields(),
            ),
            _PaymentOption(
              icon: Icons.account_balance_wallet_outlined,
              title: 'UPI',
              subtitle: 'Google Pay, PhonePe, Paytm',
              selected: paymentMethod == 1,
              onTap: () => setState(() => paymentMethod = 1),
            ),
            _PaymentOption(
              icon: Icons.payments_outlined,
              title: 'Cash or bank transfer',
              subtitle: 'Pay securely at confirmation',
              selected: paymentMethod == 2,
              onTap: () => setState(() => paymentMethod = 2),
            ),
            const SizedBox(height: 20),
            const Text(
              'Price details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            const _PriceRow(label: '₹18,500 × 4 nights', value: '₹74,000'),
            const _PriceRow(label: 'Cleaning fee', value: '₹2,500'),
            const _PriceRow(label: 'Service fee', value: '₹4,250'),
            const Divider(height: 25),
            const _PriceRow(label: 'Total (INR)', value: '₹80,750', bold: true),
            const SizedBox(height: 22),
            const Text(
              'By selecting the button below, I agree to the house rules, cancellation policy, and Havenstay terms.',
              style: TextStyle(
                fontSize: 11,
                height: 1.45,
                color: Color(0xff666666),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 12,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '₹80,750',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Total (INR)',
                      style: TextStyle(fontSize: 10, color: Color(0xff666666)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 145,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => context.push(
                    RouteName.bookingConfirmationView.replaceFirst(
                      ':propertyId',
                      'modern-villa',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffc90032),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Confirm and pay',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StayCard extends StatelessWidget {
  const _StayCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xffdddddd)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Image.network(
            'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=300',
            width: 92,
            height: 92,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 92,
              height: 92,
              color: const Color(0xffeeeeee),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Modern villa with pool',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 6),
              Text(
                'Entire villa · North Goa',
                style: TextStyle(fontSize: 11, color: Color(0xff666666)),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, size: 14),
                  SizedBox(width: 3),
                  Text('4.9 · 24 reviews', style: TextStyle(fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
  );
}

class _TripRow extends StatelessWidget {
  final IconData icon;
  final String title, value;
  const _TripRow({
    required this.icon,
    required this.title,
    required this.value,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(fontSize: 12, color: Color(0xff666666)),
            ),
          ],
        ),
      ],
    ),
  );
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final bool selected;
  final VoidCallback onTap;
  final Widget? child;
  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.child,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(9),
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: selected ? const Color(0xffc90032) : const Color(0xffdddddd),
          width: selected ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 22),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xff777777),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected
                    ? const Color(0xffc90032)
                    : const Color(0xff888888),
                size: 20,
              ),
            ],
          ),
          if (selected && child != null)
            Padding(padding: const EdgeInsets.only(top: 13), child: child!),
        ],
      ),
    ),
  );
}

class _CardFields extends StatelessWidget {
  const _CardFields();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const _Input(hint: 'Card number'),
      const SizedBox(height: 8),
      Row(
        children: [
          const Expanded(child: _Input(hint: 'Expiration date')),
          const SizedBox(width: 8),
          const Expanded(child: _Input(hint: 'CVV')),
        ],
      ),
      const SizedBox(height: 8),
      const _Input(hint: 'ZIP code'),
    ],
  );
}

class _Input extends StatelessWidget {
  final String hint;
  const _Input({required this.hint});
  @override
  Widget build(BuildContext context) => TextField(
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: Color(0xff888888)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xffdddddd)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xffdddddd)),
      ),
    ),
  );
}

class _PriceRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  const _PriceRow({
    required this.label,
    required this.value,
    this.bold = false,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
