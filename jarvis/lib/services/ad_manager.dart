import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static InterstitialAd? _interstitialAd;
  static bool _isLoading = false;

  static void loadInterstitialAd() {
    if (_isLoading) return; 
    _isLoading = true;

    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3336156603526691/1812470617', 
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isLoading = false;
          print('Interstitial ad loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
          _isLoading = false;
          Future.delayed(const Duration(seconds: 3), loadInterstitialAd);
        },
      ),
    );
  }

  static void showInterstitialAd(BuildContext context) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          loadInterstitialAd(); 
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          loadInterstitialAd();
        },
      );

      _interstitialAd!.show();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đang tải quảng cáo, vui lòng thử lại sau...'),
          duration: Duration(seconds: 2),
        ),
      );
      loadInterstitialAd();
    }
  }
}

