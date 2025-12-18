import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/products_list_page.dart';
import 'utils/page_transitions.dart';

class OrderSelectionPage extends StatelessWidget {
  const OrderSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full screen background image
          SizedBox.expand(
            child: Image.asset(
              "assets/images/2.png",
              fit: BoxFit.cover,
            ),
          ),
          // Start Now button positioned at the bottom
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    SlidePageRoute(
                      child: const ProductsListPage(),
                      direction: SlideDirection.bottomToTop,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 16,
                  ),
                  backgroundColor: const Color(0xFFb96f06),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 6,
                  shadowColor: const Color(0xFFb96f06).withOpacity(0.5),
                ),
                child: Text(
                  'Start Now',
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

