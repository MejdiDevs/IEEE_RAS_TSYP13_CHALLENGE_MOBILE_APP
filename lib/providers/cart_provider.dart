import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class CartProvider extends ChangeNotifier {
  static final CartProvider _instance = CartProvider._internal();
  factory CartProvider() => _instance;
  CartProvider._internal();

  final Cart _cart = Cart();
  bool _isInitialized = false;

  Cart get cart => _cart;

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _loadCart();
    _isInitialized = true;
  }

  Future<void> _saveCart() async {
    try {
      // Don't save if not initialized yet
      if (!_isInitialized) return;
      
      final prefs = await SharedPreferences.getInstance();
      final cartData = _cart.items.map((item) => {
        'productId': item.product.id,
        'quantity': item.quantity,
      }).toList();
      await prefs.setString('cart', jsonEncode(cartData));
    } catch (e) {
      // Silently fail - cart will work in memory
      debugPrint('Cart save failed (non-critical): $e');
    }
  }

  Future<void> _loadCart() async {
    try {
      // Add a small delay to ensure platform channels are ready
      await Future.delayed(const Duration(milliseconds: 100));
      
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString('cart');
      if (cartData != null && cartData.isNotEmpty) {
        final List<dynamic> items = jsonDecode(cartData);
        if (items.isNotEmpty) {
          final products = await ProductService.getProducts();
          if (products.isNotEmpty) {
            _cart.clear();
            for (var itemData in items) {
              try {
                final productId = itemData['productId'] as String;
                final quantity = itemData['quantity'] as int;
                final productIndex = products.indexWhere((p) => p.id == productId);
                if (productIndex >= 0) {
                  final product = products[productIndex];
                  for (int i = 0; i < quantity; i++) {
                    _cart.addItem(product);
                  }
                }
              } catch (e) {
                print('Error loading cart item: $e');
                // Skip invalid items
              }
            }
            notifyListeners();
          }
        }
      }
    } catch (e) {
      // Silently handle the error - cart will work in memory
      // This is expected on first run or if shared_preferences isn't available
      debugPrint('Cart persistence unavailable (non-critical): $e');
    }
  }

  void addToCart(Product product) {
    _cart.addItem(product);
    notifyListeners();
    _saveCart();
  }

  void removeFromCart(String productId) {
    _cart.removeItem(productId);
    notifyListeners();
    _saveCart();
  }

  void updateQuantity(String productId, int quantity) {
    _cart.updateQuantity(productId, quantity);
    notifyListeners();
    _saveCart();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
    _saveCart();
  }
}

