import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../utils/page_transitions.dart';
import '../providers/cart_provider.dart';
import '../widgets/skeleton_loader.dart';
import 'product_detail_page.dart';
import 'cart_page.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _applyFilters();
    });
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery) ||
          product.description.toLowerCase().contains(_searchQuery);
      
      // Simple category filter based on product name keywords
      final matchesCategory = _selectedCategory == null ||
          product.name.toLowerCase().contains(_selectedCategory!.toLowerCase());
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<String> _getCategories() {
    final categories = <String>{};
    for (var product in _products) {
      // Extract simple categories from product names
      final name = product.name.toLowerCase();
      if (name.contains('headphone') || name.contains('earphone')) {
        categories.add('Audio');
      } else if (name.contains('watch')) {
        categories.add('Wearables');
      } else if (name.contains('laptop') || name.contains('keyboard') || name.contains('mouse')) {
        categories.add('Computer');
      } else if (name.contains('phone')) {
        categories.add('Mobile');
      } else {
        categories.add('Other');
      }
    }
    return categories.toList()..sort();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final products = await ProductService.getProducts();
      print('Loaded ${products.length} products');
      
      setState(() {
        _products = products;
        _filteredProducts = products;
        _isLoading = false;
      });
      
      if (products.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No products found. Make sure products are added to Firestore.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error in _loadProducts: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading products: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF4F4F4),
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: SkeletonLoader(
                    width: double.infinity,
                    height: 24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const ProductCardSkeleton(),
                    childCount: 6,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    if (_products.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'No products found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Make sure products are added to Firestore',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadProducts,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          _CartIconWithBadge(
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
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF4F4F4),
        ),
        child: RefreshIndicator(
          onRefresh: _loadProducts,
          child: CustomScrollView(
            slivers: [
              // Phrase at the top
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Text(
                    'Discover Our Newest Products',
                    style: GoogleFonts.orbitron(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF57135C), // Primary Purple
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              // Large image banner
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  height: 180,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Placeholder gradient background - replace with actual image
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF57135C), // Primary Purple
                                const Color(0xFF023EAC), // Blue
                              ],
                            ),
                          ),
                        ),
                        // Overlay content with text and logo
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Summer Sale',
                                      style: GoogleFonts.orbitron(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Up to 75% OFF',
                                      style: GoogleFonts.orbitron(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // RAS logo
                              Image.asset(
                                'assets/images/RAS_white.png',
                                height: 80,
                                width: 80,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Search bar
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
              // Category filters
              if (_getCategories().isNotEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 32,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _getCategories().length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          final isSelected = _selectedCategory == null;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _CustomFilterChip(
                              label: 'All',
                              isSelected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = null;
                                  _applyFilters();
                                });
                              },
                            ),
                          );
                        }
                        final category = _getCategories()[index - 1];
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _CustomFilterChip(
                            label: category,
                            isSelected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = selected ? category : null;
                                _applyFilters();
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              // Products grid or empty state
              _filteredProducts.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              'No products found',
                              style: GoogleFonts.orbitron(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your search or filters',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.72,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = _filteredProducts[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: _buildProductCard(product),
                              ),
                            );
                          },
                          childCount: _filteredProducts.length,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Image section with padding
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          ScalePageRoute(
                            child: ProductDetailPage(product: product),
                          ),
                        );
                      },
                      child: product.imagePath.startsWith('http://') || 
                             product.imagePath.startsWith('https://')
                        ? Image.network(
                            product.imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            cacheWidth: 300,
                            cacheHeight: 300,
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
                            product.imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            cacheWidth: 300,
                            cacheHeight: 300,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                          ),
                    ),
                  ),
                  // Floating discount badge in top right
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF023EAC), // Blue
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '45% OFF',
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
                    // Content section with minimal padding
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                ScalePageRoute(
                                  child: ProductDetailPage(product: product),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  product.name,
                                  style: GoogleFonts.orbitron(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: const Color(0xFF3F3F3F),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                // Price, rating, and add button in same row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Price with discount
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  '\$${product.price.toStringAsFixed(2)}',
                                                  style: GoogleFonts.orbitron(
                                                    color: const Color(0xFF57135C),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 2),
                                              Flexible(
                                                child: Text(
                                                  '\$${(product.price * 2.23).toStringAsFixed(2)}',
                                                  style: GoogleFonts.inter(
                                                    color: Colors.grey[600],
                                                    fontSize: 8,
                                                    decoration: TextDecoration.lineThrough,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 1),
                                          // Rating
                                          Row(
                                            children: [
                                              const Icon(Icons.star, color: Colors.amber, size: 11),
                                              const SizedBox(width: 1),
                                              Flexible(
                                                child: Text(
                                                  '4.9 (256)',
                                                  style: GoogleFonts.inter(
                                                    color: Colors.grey[600],
                                                    fontSize: 8,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Square add to cart button
                                    _AddToCartButton(product: product),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
  }
}

// Add to cart button that changes icon when item is in cart
class _AddToCartButton extends StatefulWidget {
  final Product product;

  const _AddToCartButton({required this.product});

  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<_AddToCartButton> {
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

  bool get _isInCart {
    return _cartProvider.cart.items.any((item) => item.product.id == widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: ElevatedButton(
        onPressed: () {
          if (_isInCart) {
            // Remove from cart
            _cartProvider.removeFromCart(widget.product.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${widget.product.name} removed from cart'),
                backgroundColor: const Color(0xFF57135C),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            );
          } else {
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
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: _isInCart 
              ? const Color(0xFF023EAC) // Blue from color palette
              : const Color(0xFF57135C), // Primary Purple
          foregroundColor: Colors.white,
          minimumSize: const Size(32, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Icon(
          _isInCart ? Icons.close : Icons.add_shopping_cart,
          size: 14,
        ),
      ),
    );
  }
}

// Cart icon with badge showing item count
class _CartIconWithBadge extends StatefulWidget {
  final VoidCallback onPressed;

  const _CartIconWithBadge({required this.onPressed});

  @override
  State<_CartIconWithBadge> createState() => _CartIconWithBadgeState();
}

class _CartIconWithBadgeState extends State<_CartIconWithBadge> {
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
    final itemCount = _cartProvider.cart.itemCount;
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: widget.onPressed,
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
    );
  }
}

// Custom Filter Chip with gradient support
class _CustomFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const _CustomFilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelected(!isSelected),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        constraints: const BoxConstraints(
          minHeight: 0
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    Color(0xFF57135C), // Primary Purple
                    Color(0xFF023EAC), // Blue
                  ],
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

