import 'package:flutter/material.dart';
import 'package:jarvis/components/sideBar.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/pricing_page/widgets/pricing_plan_card.dart';
import 'package:jarvis/pages/pricing_page/widgets/feature_chip.dart';

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
            Image.asset('assets/logos/jarvis.png', width: 24, height: 24,), 
            SizedBox(width: 8),
            Text(
              "Jarvis",
              style: const TextStyle(color: jvDeepBlue, fontWeight: FontWeight.bold),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Pricing',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Jarvis - Best AI Assistant Powered by GPT',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: jvDeepBlue
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Upgrade plan now for a seamless, user-friendly experience.\nUnlock the full potential of our app and enjoy convenience at your fingertips.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PricingPlanCard(
                    title: 'Basic',
                    price: 'Free',
                    features: [
                      {'text': 'AI Chat Model', 'subText': 'GPT-3.5'},
                      {'text': 'Ai Action Injection'},
                      {'text': 'Select Text for AI Action'},
                    ],
                    buttonText: 'Sign up to subscribe',
                    onPressed: () {},
                    buttonTextColor: jvDeepBlue,
                    buttonBgColor: jvGrey,
                  ),
                  SizedBox(width: 16),
                  PricingPlanCard(
                    title: 'Starter',
                    price: '1-month Free Trial',
                    features: [
                      {'text': 'AI Chat Models', 'subText': 'GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra'},
                      {'text': 'AI Action Injection'},
                      {'text': 'Select Text for AI Action'},
                    ],
                    buttonText: 'Sign up to subscribe',
                    onPressed: () {},
                    buttonTextColor: Colors.white,
                    buttonBgColor: jvBlue,
                  ),
                  SizedBox(width: 16),
                  PricingPlanCard(
                    title: 'Pro Annually',
                    price: '1-month Free Trial',
                    features: [
                      {'text': 'AI Chat Models', 'subText': 'GPT-3.5 & GPT-4.0/Turbo & Gemini Pro & Gemini Ultra'},
                      {'text': 'AI Action Injection'},
                      {'text': 'Select Text for AI Action'},
                    ],
                    buttonText: 'Sign up to subscribe',
                    onPressed: () {},
                    buttonTextColor: Colors.white,
                    buttonBgColor: Colors.amber ,
                  ),
                ],
              ),
              SizedBox(height: 64),
              Text(
                '* Our subscription plan is designed with flexibility and transparency in mind. While it offers unlimited usage, we acknowledge the possibility of adjustments in the future to meet evolving needs. Rest assured, any such changes will be communicated well in advance, providing our customers with the information they need to make informed decisions. Additionally, we understand that adjustments may not align with everyone\'s expectations, which is why we\'ve implemented a generous refund program. Subscribers can terminate their subscription within 7 days of the announced adjustments and receive a refund if they so choose. Moreover, our commitment to customer satisfaction is further emphasized by allowing subscribers the freedom to cancel their subscription at any time, providing ultimate flexibility in managing their subscription preferences.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}