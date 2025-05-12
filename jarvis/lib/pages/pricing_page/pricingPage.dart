import 'package:flutter/material.dart';
import 'package:jarvis/components/sideBar.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/pricing_page/pricing_plan_card.dart';
import 'package:jarvis/services/ad_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:jarvis/services/iap_manager.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PricingPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideBar(selectedIndex: 4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Image.asset('assets/logos/jarvis.png', width: 24, height: 24),
            SizedBox(width: 8),
            Text(
              "Jarvis",
              style: const TextStyle(
                color: jvDeepBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: Consumer<IAPManager>(
          builder: (context, iapManager, child) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Pricing',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'Jarvis - Best AI Assistant Powered by GPT',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: jvDeepBlue,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'Upgrade plan now for a seamless, user-friendly experience.\nUnlock the full potential of our app and enjoy convenience at your fingertips.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  PricingPlanCard(
                    title: 'Basic',
                    price: 'Free',
                    features: [
                      {'text': 'AI Chat Model', 'subText': 'GPT-3.5'},
                      {'text': 'Ai Action Injection'},
                      {'text': 'Select Text for AI Action'},
                    ],
                    buttonText: 'Subscribe Now',
                    onPressed: () async {
                      const url = 'https://dev.jarvis.cx/pricing';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    buttonTextColor: jvDeepBlue,
                    buttonBgColor: jvGrey,
                  ),
                  PricingPlanCard(
                    title: 'Starter',
                    price: '1-month Free Trial',
                    features: [
                      {
                        'text': 'AI Chat Models',
                        'subText':
                            'GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra',
                      },
                      {'text': 'AI Action Injection'},
                      {'text': 'Select Text for AI Action'},
                    ],
                    buttonText: 'Subscribe Now',
                    onPressed: () {if (!kIsWeb) {AdManager.showInterstitialAd(context);}},
                    buttonTextColor: Colors.white,
                    buttonBgColor: jvBlue,
                  ),
                  PricingPlanCard(
                    title: 'Pro Annually',
                    price: iapManager.products.isNotEmpty
                        ? iapManager.products[0].price
                        : '1-month Free Trial',
                    features: [
                      {
                        'text': 'AI Chat Models',
                        'subText': 'GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra',
                      },
                      {'text': 'AI Action Injection'},
                      {'text': 'Select Text for AI Action'},
                    ],
                    buttonText: iapManager.loading
                        ? 'Processing...'
                        : 'Subscribe Now',
                    onPressed: iapManager.loading || iapManager.products.isEmpty
                        ? () {}
                        : () {
                            if (!kIsWeb && iapManager.isAvailable) {
                              iapManager.buyProduct(iapManager.products[0]);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('In-App Purchase is not available'),
                                ),
                              );
                            }
                          },
                    buttonTextColor: Colors.white,
                    buttonBgColor: Colors.amber,
                  ),
                ],
              ),
              SizedBox(height: 64),
              Text(
                '* Our subscription plan is designed with flexibility and transparency in mind. While it offers unlimited usage, we acknowledge the possibility of adjustments in the future to meet evolving needs. Rest assured, any such changes will be communicated well in advance, providing our customers with the information they need to make informed decisions. Additionally, we understand that adjustments may not align with everyone\'s expectations, which is why we\'ve implemented a generous refund program. Subscribers can terminate their subscription within 7 days of the announced adjustments and receive a refund if they so choose. Moreover, our commitment to customer satisfaction is further emphasized by allowing subscribers the freedom to cancel their subscription at any time, providing ultimate flexibility in managing their subscription preferences.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      );
          },
      ),
    );
  }
}
