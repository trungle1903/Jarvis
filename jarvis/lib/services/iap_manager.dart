import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IAPManager with ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _loading = false;
  String? _error;

  bool get isAvailable => _isAvailable;
  bool get loading => _loading;
  String? get error => _error;
  List<ProductDetails> get products => _products;

  Future<void> initialize() async {
    _loading = true;
    notifyListeners();
    try {
      _isAvailable = await _inAppPurchase.isAvailable();
      if (_isAvailable) {
        _subscription = _inAppPurchase.purchaseStream.listen(
          _listenToPurchaseUpdated,
          onDone: () => _subscription?.cancel(),
          onError: (error) => _setError(error.toString()),
        );
        await _loadProducts();
      } else {
        _setError('In-App Purchase is not available');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _loadProducts() async {
    const Set<String> productIds = {'pro_annually_subscription'}; // Thay bằng Product ID của bạn
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);
    if (response.notFoundIDs.isNotEmpty) {
      _setError('Some products were not found: ${response.notFoundIDs}');
      return;
    }
    _products = response.productDetails;
    notifyListeners();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        _setError(purchaseDetails.error?.message ?? 'Purchase failed');
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                 purchaseDetails.status == PurchaseStatus.restored) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('pro_annually_subscription', true);
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        _setError('Purchase was canceled');
      }
    }
    notifyListeners();
  }

  Future<void> buyProduct(ProductDetails product) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      _setError(e.toString());
      notifyListeners();
    }
  }

  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      _setError(e.toString());
      notifyListeners();
    }
  }

  void _setError(String error) {
    _error = error;
    _loading = false;
    notifyListeners();
  }

  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}