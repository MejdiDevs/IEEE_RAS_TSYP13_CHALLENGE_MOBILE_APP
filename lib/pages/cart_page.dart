import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../utils/page_transitions.dart';
import '../main.dart';
import 'order_history_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartProvider _cartProvider = CartProvider();
  
  @override
  void initState() {
    super.initState();
    _cartProvider.addListener(_onCartChanged);
  }
  
  @override
  void dispose() {
    _cartProvider.removeListener(_onCartChanged);
    super.dispose();
  }
  
  void _onCartChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cart = _cartProvider.cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                SlidePageRoute(
                  child: const OrderHistoryPage(),
                  direction: SlideDirection.leftToRight,
                ),
              );
            },
            tooltip: 'Order History',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF4F4F4),
        ),
        child: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: item.product.imagePath.startsWith('http://') || 
                                           item.product.imagePath.startsWith('https://')
                                        ? Image.network(
                                            item.product.imagePath,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.image_not_supported),
                                              );
                                            },
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Container(
                                                color: Colors.grey[200],
                                                child: const Center(
                                                  child: CircularProgressIndicator(strokeWidth: 2),
                                                ),
                                              );
                                            },
                                          )
                                        : Image.asset(
                                            item.product.imagePath,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.image_not_supported),
                                              );
                                            },
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Product name
                                      Text(
                                        item.product.name,
                                        style: GoogleFonts.orbitron(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: const Color(0xFF3F3F3F),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Price with discount
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              '\$${item.product.price.toStringAsFixed(2)}',
                                              style: GoogleFonts.orbitron(
                                                color: const Color(0xFF57135C), // Primary Purple
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Flexible(
                                            child: Text(
                                              '\$${(item.product.price * 2.23).toStringAsFixed(2)}', // Original price
                                              style: GoogleFonts.inter(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Discount badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF023EAC), // Blue
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '45% OFF',
                                          style: GoogleFonts.orbitron(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Delete icon and Quantity controls row
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Delete icon
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline),
                                            color: Colors.red[400],
                                            onPressed: () {
                                              _cartProvider.removeFromCart(item.product.id);
                                            },
                                          ),
                                          // Quantity controls
                                          Container(
                                            height: 28,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xFF57135C), // Primary Purple
                                                width: 1.5,
                                              ),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Minus button
                                                InkWell(
                                                  onTap: () {
                                                    if (item.quantity > 1) {
                                                      _cartProvider.updateQuantity(
                                                        item.product.id,
                                                        item.quantity - 1,
                                                      );
                                                    } else {
                                                      _cartProvider.removeFromCart(item.product.id);
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 28,
                                                    height: 28,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '-',
                                                      style: GoogleFonts.orbitron(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: const Color(0xFF57135C), // Primary Purple
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // Quantity number
                                                Container(
                                                  width: 28,
                                                  height: 28,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '${item.quantity}',
                                                    style: GoogleFonts.orbitron(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xFF3F3F3F),
                                                    ),
                                                  ),
                                                ),
                                                // Plus button
                                                InkWell(
                                                  onTap: () {
                                                    _cartProvider.updateQuantity(
                                                      item.product.id,
                                                      item.quantity + 1,
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 28,
                                                    height: 28,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '+',
                                                      style: GoogleFonts.orbitron(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: const Color(0xFF57135C), // Primary Purple
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '\$${cart.totalPrice.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              SlidePageRoute(
                                child: OrderPage(
                                  cartItems: cart.items,
                                ),
                                direction: SlideDirection.bottomToTop,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF57135C), // Primary Purple
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'Proceed To Checkout',
                            style: GoogleFonts.orbitron(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }
}

