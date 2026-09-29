import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../resources/constants/app_colors.dart';

enum ProfileWebDocument { terms, privacy, about }

class ProfileInformationWebViewScreen extends StatefulWidget {
  final ProfileWebDocument document;

  const ProfileInformationWebViewScreen({
    super.key,
    required this.document,
  });

  @override
  State<ProfileInformationWebViewScreen> createState() =>
      _ProfileInformationWebViewScreenState();
}

class _ProfileInformationWebViewScreenState
    extends State<ProfileInformationWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    final document = _document;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setBackgroundColor(const Color(0xFFF7F7F7))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (_) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _hasError = true;
              });
            }
          },
        ),
      )
      ..loadHtmlString(document.toHtml());
  }

  _ProfileWebDocumentData get _document => switch (widget.document) {
    ProfileWebDocument.terms => _termsDocument,
    ProfileWebDocument.privacy => _privacyDocument,
    ProfileWebDocument.about => _aboutDocument,
  };

  @override
  Widget build(BuildContext context) {
    final document = _document;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        title: Text(
          document.title,
          style: const TextStyle(
            color: AppColor.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          if (!_hasError) WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            ),
          if (_hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      size: 42,
                      color: AppColor.textSecondary,
                    ),
                    const SizedBox(height: 12),
                    const Text('This page could not be displayed.'),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _isLoading = true;
                        });
                        _controller.loadHtmlString(document.toHtml());
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfileWebDocumentData {
  final String title;
  final String eyebrow;
  final String introduction;
  final List<_ProfileWebSection> sections;

  const _ProfileWebDocumentData({
    required this.title,
    required this.eyebrow,
    required this.introduction,
    required this.sections,
  });

  String toHtml() {
    final sectionMarkup = sections.map((section) {
      final paragraphs = section.paragraphs
          .map((paragraph) => '<p>${htmlEscape.convert(paragraph)}</p>')
          .join();
      final bullets = section.bullets.isEmpty
          ? ''
          : '<ul>${section.bullets.map((item) => '<li>${htmlEscape.convert(item)}</li>').join()}</ul>';
      return '<section><h2>${htmlEscape.convert(section.title)}</h2>$paragraphs$bullets</section>';
    }).join();

    return '''
<!doctype html>
<html lang="en">
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta charset="utf-8">
  <style>
    :root { color-scheme: light; }
    * { box-sizing: border-box; }
    body { margin: 0; padding: 20px 18px 36px; background: #f7f7f7; color: #222222; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }
    .hero { padding: 25px 22px 24px; border-radius: 22px; background: linear-gradient(135deg, #fff0f2, #ffffff 78%); border: 1px solid #f4e4e6; }
    .brand { display: inline-flex; align-items: center; gap: 9px; color: #b51f3b; font-size: 12px; font-weight: 800; letter-spacing: 1.4px; }
    .mark { display: grid; width: 30px; height: 30px; place-items: center; border-radius: 10px; background: #ff385c; color: #fff; font-size: 15px; letter-spacing: 0; }
    .eyebrow { margin-top: 20px; color: #b51f3b; font-size: 11px; font-weight: 800; letter-spacing: 1.3px; text-transform: uppercase; }
    h1 { margin: 8px 0 9px; font-size: 28px; line-height: 1.2; letter-spacing: -0.7px; }
    .intro { margin: 0; color: #626262; font-size: 15px; line-height: 1.65; }
    section { margin-top: 14px; padding: 21px 20px; border: 1px solid #eeeeee; border-radius: 18px; background: #fff; }
    h2 { margin: 0 0 10px; font-size: 17px; line-height: 1.35; }
    p, li { color: #5f5f5f; font-size: 14px; line-height: 1.7; }
    p { margin: 0 0 10px; }
    p:last-child { margin-bottom: 0; }
    ul { margin: 5px 0 0; padding-left: 20px; }
    li { padding-left: 3px; margin: 5px 0; }
    footer { padding: 25px 8px 0; color: #8a8a8a; text-align: center; font-size: 12px; }
  </style>
</head>
<body>
  <header class="hero">
    <div class="brand"><span class="mark">G</span> GOANEST</div>
    <div class="eyebrow">${htmlEscape.convert(eyebrow)}</div>
    <h1>${htmlEscape.convert(title)}</h1>
    <p class="intro">${htmlEscape.convert(introduction)}</p>
  </header>
  $sectionMarkup
  <footer>GoaNest · Travel at your own pace</footer>
</body>
</html>
''';
  }
}

class _ProfileWebSection {
  final String title;
  final List<String> paragraphs;
  final List<String> bullets;

  const _ProfileWebSection(
    this.title, {
    this.paragraphs = const [],
    this.bullets = const [],
  });
}

const _termsDocument = _ProfileWebDocumentData(
  title: 'Terms & Conditions',
  eyebrow: 'A few things to know',
  introduction:
      'These terms explain the basics of using GoaNest to discover places and plan a stay. By using the app, you agree to use it responsibly.',
  sections: [
    _ProfileWebSection(
      'Your account',
      paragraphs: [
        'Keep your account details accurate and protect your sign-in information. Activity completed through your account is your responsibility. Contact support if you believe someone else has accessed it.',
      ],
    ),
    _ProfileWebSection(
      'Listings and reservations',
      paragraphs: [
        'Property details are provided to help you make an informed choice. Review the listing, dates, total price, house rules, and cancellation terms before confirming a reservation.',
        'A reservation is subject to availability and the confirmation shown in the app. If plans change, use the booking details and cancellation terms shown for that reservation.',
      ],
    ),
    _ProfileWebSection(
      'Using GoaNest respectfully',
      paragraphs: [
        'Use the app lawfully and treat hosts, guests, and support staff with respect. Do not submit misleading information, misuse another person’s account, interfere with the service, or use GoaNest to harm others.',
      ],
    ),
    _ProfileWebSection(
      'Our service',
      paragraphs: [
        'We may update app features and listing information as the service changes. We aim to make the app useful and reliable, but availability and displayed details can change; please check the latest information before you book.',
      ],
    ),
    _ProfileWebSection(
      'Questions',
      paragraphs: [
        'For help with these terms or a reservation, open Help Center from your profile and use the available support options.',
      ],
    ),
  ],
);

const _privacyDocument = _ProfileWebDocumentData(
  title: 'Privacy Policy',
  eyebrow: 'Your information matters',
  introduction:
      'This overview explains the information GoaNest uses to provide account, discovery, and reservation features in the app.',
  sections: [
    _ProfileWebSection(
      'Information you provide',
      paragraphs: [
        'Depending on how you use GoaNest, this may include your name, email address, phone number, profile details, reservation information, and messages or questions sent to support.',
      ],
    ),
    _ProfileWebSection(
      'App activity',
      paragraphs: [
        'The app may keep information about places you save, recently view, search for, or include in a reservation so those features work across your account.',
      ],
    ),
    _ProfileWebSection(
      'How information is used',
      bullets: [
        'To sign you in and maintain your account.',
        'To show listings and reservation details you request.',
        'To provide saved places, recently viewed items, and other app features.',
        'To respond to support requests and help protect the service.',
      ],
    ),
    _ProfileWebSection(
      'Sharing and protection',
      paragraphs: [
        'Information is used to operate the features you choose. Details needed to arrange a reservation may be shared with the relevant service participants. We do not ask you to place passwords or payment card details in profile text or support messages.',
        'Use a strong, private password and sign out on devices you do not control. If you have a question about information associated with your account, contact support through Help Center.',
      ],
    ),
    _ProfileWebSection(
      'Your choices',
      paragraphs: [
        'You can review and update available profile details from Personal information in your profile. For questions or requests about your account information, use the Help Center in the app.',
      ],
    ),
  ],
);

const _aboutDocument = _ProfileWebDocumentData(
  title: 'About GoaNest',
  eyebrow: 'Find your place in Goa',
  introduction:
      'GoaNest helps you explore stays and plan the details of your next Goa trip, all from one welcoming place.',
  sections: [
    _ProfileWebSection(
      'Discover places to stay',
      paragraphs: [
        'Browse homes and properties, explore categories, and open listing details to find a stay that suits your trip.',
      ],
    ),
    _ProfileWebSection(
      'Plan at your pace',
      paragraphs: [
        'Save places you like, revisit recently viewed listings, and manage reservation details from your account.',
      ],
    ),
    _ProfileWebSection(
      'Here to help',
      paragraphs: [
        'Visit Help Center from your profile for frequently asked questions and the support options available in the app.',
      ],
    ),
    _ProfileWebSection(
      'GoaNest',
      paragraphs: ['Made for discovering Goa, one stay at a time.'],
    ),
  ],
);
