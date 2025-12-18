import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/product_service.dart';
import '../widgets/fullscreen_image_viewer.dart';
import '../utils/page_transitions.dart';
import 'cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final CartProvider _cartProvider = CartProvider();
  List<Product> _allProducts = [];
  List<Product> _relatedProducts = [];

  @override
  void initState() {
    super.initState();
    _cartProvider.addListener(_onCartChanged);
    _loadRelatedProducts();
  }

  Future<void> _loadRelatedProducts() async {
    try {
      final products = await ProductService.getProducts();
      setState(() {
        _allProducts = products;
        // Get related products (exclude current product, take first 4)
        _relatedProducts = products
            .where((p) => p.id != widget.product.id)
            .take(4)
            .toList();
      });
    } catch (e) {
      print('Error loading related products: $e');
    }
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
    final itemCount = _cartProvider.cart.itemCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF57135C),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Product Details',
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    SlidePageRoute(
                      child: const CartPage(),
                      direction: SlideDirection.rightToLeft,
                    ),
                  );
                },
              ),
              if (itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      itemCount > 99 ? '99+' : itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullscreenImageViewer(
                                imagePath: widget.product.imagePath,
                                heroTag: 'product_${widget.product.id}',
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'product_${widget.product.id}',
                          child: widget.product.imagePath.startsWith('http://') || 
                                 widget.product.imagePath.startsWith('https://')
                            ? Image.network(
                                widget.product.imagePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image_not_supported, size: 64),
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Image.asset(
                                widget.product.imagePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image_not_supported, size: 64),
                                  );
                                },
                              ),
                        ),
                      ),
                    ),
                  ),
                  // Discount badge
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF023EAC), // Blue
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                                '45% OFF',
                                style: GoogleFonts.orbitron(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Info Section
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.product.name,
                    style: GoogleFonts.orbitron(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3F3F3F),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Price and Rating Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Price with discount
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '\$${widget.product.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.orbitron(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF57135C), // Primary Purple
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '\$${(widget.product.price * 2.23).toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Rating
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  '4.9 (256 reviews)',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Description Section
                  Text(
                    'Description',
                    style: GoogleFonts.orbitron(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3F3F3F),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.product.description,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _cartProvider.addToCart(widget.product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.product.name} added to cart'),
                            backgroundColor: const Color(0xFF023EAC), // Blue from color palette
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'View Cart',
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  SlidePageRoute(
                                    child: const CartPage(),
                                    direction: SlideDirection.rightToLeft,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart, size: 24),
                      label: Text(
                        'Add to Cart',
                        style: GoogleFonts.orbitron(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF57135C), // Primary Purple
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Related Products Section
            if (_relatedProducts.isNotEmpty) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Related Products',
                      style: GoogleFonts.orbitron(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3F3F3F),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _relatedProducts.length,
                        itemBuilder: (context, index) {
                          final product = _relatedProducts[index];
                          return Container(
                            width: 150,
                            margin: const EdgeInsets.only(right: 12),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    ScalePageRoute(
                                      child: ProductDetailPage(product: product),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Product image
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        child: product.imagePath.startsWith('http://') ||
                                                product.imagePath.startsWith('https://')
                                            ? Image.network(
                                                product.imagePath,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey[300],
                                                    child: const Icon(Icons.image_not_supported),
                                                  );
                                                },
                                              )
                                            : Image.asset(
                                                product.imagePath,
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
                                    // Product info
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: GoogleFonts.orbitron(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '\$${product.price.toStringAsFixed(2)}',
                                            style: GoogleFonts.orbitron(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF57135C),
                                            ),
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
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

