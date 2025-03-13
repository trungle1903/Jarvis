import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jarvis/components/historyDrawer.dart';
import 'package:jarvis/pages/plan_pricing_page/widgets/planContainer.dart';

class PlanPricingPage extends StatefulWidget {
  const PlanPricingPage({super.key});

  @override
  State<PlanPricingPage> createState() => _PlanPricingPageState();
}

class _PlanPricingPageState extends State<PlanPricingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: HistoryDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Upgrade your plan",
                  style: GoogleFonts.jetBrainsMono(
                      fontWeight: FontWeight.w800,
                      fontSize: MediaQuery.of(context).size.width * 0.05)),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          PlanContainer(planName: "Free", price: 0, onClick: () {print("Yes");}, isCurrentPlan: true,),
          SizedBox(height: 30,),
          PlanContainer(planName: "Plus", price: 200, onClick: () {print("Yes");}, isCurrentPlan: false,),
        ],
      ),
    );
  }


  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: false,
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      title: Text("Plan & Pricing",
          style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w800)),
    );
  }
}
