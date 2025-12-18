import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'services/firebase_service.dart';
import 'services/order_service.dart';
import 'welcome_page.dart';
import 'order_selection_page.dart';
import 'tracking_page.dart';
import 'models/product.dart';
import 'pages/products_list_page.dart';
import 'pages/order_history_page.dart';
import 'providers/cart_provider.dart';
import 'utils/page_transitions.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const MyApp());
  
  // Initialize cart persistence after app starts (delayed to avoid channel errors)
  // If it fails, cart will still work in memory
  Future.delayed(const Duration(milliseconds: 500), () {
    CartProvider().initialize().catchError((e) {
      print('Cart initialization error (non-critical): $e');
    });
  });
}

// HomeHaven design system - Custom text theme with Orbitron (primary) and Inter (secondary)
TextTheme _buildTextTheme() {
  // Primary font: Orbitron (for headings and titles) - futuristic, modern font
  final primaryFont = GoogleFonts.orbitron();
  // Secondary font: Inter (for body text and descriptions)
  final secondaryFont = GoogleFonts.inter();
  
  final baseTheme = ThemeData.light().textTheme;
  
  return TextTheme(
    // Display styles - use Poppins (primary)
    displayLarge: primaryFont.copyWith(
      fontSize: baseTheme.displayLarge?.fontSize ?? 57,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF57135C), // Primary Purple
    ),
    displayMedium: primaryFont.copyWith(
      fontSize: baseTheme.displayMedium?.fontSize ?? 45,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF57135C), // Primary Purple
    ),
    displaySmall: primaryFont.copyWith(
      fontSize: baseTheme.displaySmall?.fontSize ?? 36,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF57135C), // Primary Purple
    ),
    // Headline styles - use Poppins (primary)
    headlineLarge: primaryFont.copyWith(
      fontSize: baseTheme.headlineLarge?.fontSize ?? 32,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF57135C), // Primary Purple
    ),
    headlineMedium: primaryFont.copyWith(
      fontSize: baseTheme.headlineMedium?.fontSize ?? 28,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF156650),
    ),
    headlineSmall: primaryFont.copyWith(
      fontSize: baseTheme.headlineSmall?.fontSize ?? 24,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF3F3F3F),
    ),
    // Title styles - use Poppins (primary)
    titleLarge: primaryFont.copyWith(
      fontSize: baseTheme.titleLarge?.fontSize ?? 22,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF3F3F3F),
    ),
    titleMedium: primaryFont.copyWith(
      fontSize: baseTheme.titleMedium?.fontSize ?? 16,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF3F3F3F),
    ),
    titleSmall: primaryFont.copyWith(
      fontSize: baseTheme.titleSmall?.fontSize ?? 14,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF3F3F3F),
    ),
    // Body styles - use Inter (secondary)
    bodyLarge: secondaryFont.copyWith(
      fontSize: baseTheme.bodyLarge?.fontSize ?? 16,
      color: const Color(0xFF3F3F3F),
    ),
    bodyMedium: secondaryFont.copyWith(
      fontSize: baseTheme.bodyMedium?.fontSize ?? 14,
      color: const Color(0xFF3F3F3F),
    ),
    bodySmall: secondaryFont.copyWith(
      fontSize: baseTheme.bodySmall?.fontSize ?? 12,
      color: const Color(0xFF3F3F3F),
    ),
    // Label styles - use Inter (secondary)
    labelLarge: secondaryFont.copyWith(
      fontSize: baseTheme.labelLarge?.fontSize ?? 14,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF3F3F3F),
    ),
    labelMedium: secondaryFont.copyWith(
      fontSize: baseTheme.labelMedium?.fontSize ?? 12,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF3F3F3F),
    ),
    labelSmall: secondaryFont.copyWith(
      fontSize: baseTheme.labelSmall?.fontSize ?? 11,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF3F3F3F),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Client Order Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Updated color palette - Purple/Blue scheme
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF57135C), // Primary Purple
          secondary: const Color(0xFF023EAC), // Blue
          tertiary: const Color(0xFF085FD2), // Light Blue
          surface: Colors.white,
          background: const Color(0xFFF4F4F4), // Light gray background
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: const Color(0xFF3F3F3F), // Dark gray text
          onBackground: const Color(0xFF3F3F3F),
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F4F4),
        useMaterial3: true,
        textTheme: _buildTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF57135C), // Primary Purple
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.orbitron(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF57135C), // Primary Purple
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            elevation: 2,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF57135C), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      home: const WelcomePage(),
      routes: {
        '/page2': (context) => const OrderSelectionPage(),
        '/order': (context) => const OrderPage(),
      },
    );
  }
}

class OrderPage extends StatefulWidget {
  final List<CartItem>? cartItems;
  
  const OrderPage({super.key, this.cartItems});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  LatLng? _selectedLocation;
  final LatLng _initialCenter = const LatLng(34.740083, 10.748778);
  MapController? _mapController;
  bool _mapInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize map controller and delay map rendering to prevent blocking UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _mapController = MapController();
            _mapInitialized = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String get _productName {
    if (widget.cartItems != null && widget.cartItems!.isNotEmpty) {
      return widget.cartItems!.map((item) => item.product.name).join(', ');
    }
    return 'Order';
  }

  Future<void> _submitOrder() async {
    if (!(_formKey.currentState!.validate() && _selectedLocation != null)) {
      String message = 'Please fill all fields';
      if (_selectedLocation == null) {
        message += ' and select a location on the map';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Create task in Firestore
      final taskId = await FirebaseService.createTask(
        assignedTo: 'vehA', // You can make this dynamic later
        x: _selectedLocation!.latitude,
        y: _selectedLocation!.longitude,
      );

      // Save order to Firestore
      final cartProvider = CartProvider();
      final cart = cartProvider.cart;
      
      await OrderService.saveOrder(
        fullName: _fullNameController.text,
        phone: _phoneController.text,
        items: cart.items,
        totalPrice: cart.totalPrice,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
      );

      // Clear the cart after successful order
      cartProvider.clearCart();

      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Navigate to success page
      if (context.mounted) {
        Navigator.push(
          context,
          ScalePageRoute(
            child: OrderSuccessPage(
              fullName: _fullNameController.text,
              product: _productName,
            ),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error placing order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Order Page'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF4F4F4),
        ),
        child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              if (widget.cartItems != null && widget.cartItems!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFF57135C), // Primary Purple
                    ),
                    child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 8),
                        ...widget.cartItems!.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '${item.product.name} x${item.quantity} - \$${item.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        )),
                        Divider(color: Colors.white.withOpacity(0.3)),
                        Text(
                          'Total: \$${widget.cartItems!.fold(0.0, (sum, item) => sum + item.totalPrice).toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value!.isEmpty ? 'Enter your full name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) => value!.isEmpty ? 'Enter your phone number' : null,
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          const Icon(Icons.map, color: Color(0xFF57135C)),
                          const SizedBox(width: 8),
                          Text(
                            'Select Delivery Location',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                        child: _mapInitialized && _mapController != null
                          ? FlutterMap(
                              mapController: _mapController!,
                              options: MapOptions(
                                initialCenter: _initialCenter,
                                initialZoom: 13,
                                onTap: (tapPosition, latLng) {
                                  setState(() {
                                    _selectedLocation = latLng;
                                  });
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  userAgentPackageName: 'com.ras.beefast',
                                  maxZoom: 19,
                                ),
                                MarkerLayer(
                                  markers: [
                                    if (_selectedLocation != null)
                                      Marker(
                                        point: _selectedLocation!,
                                        width: 40,
                                        height: 40,
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Color(0xFF57135C),
                                          size: 40,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            )
                          : Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitOrder,
                icon: const Icon(Icons.send),
                label: Text(
                  'Submit Order',
                  style: GoogleFonts.orbitron(),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}

class OrderSuccessPage extends StatelessWidget {
  final String fullName;
  final String product;

  const OrderSuccessPage({
    super.key,
    required this.fullName,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Successful'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 16),
              Text(
                'Thank you, $fullName!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your order for $product has been placed successfully.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    SlidePageRoute(
                      child: const ProductsListPage(),
                      direction: SlideDirection.leftToRight,
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.shopping_bag),
                label: const Text('Back to Products'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
