import 'package:flutter/material.dart';

class FullscreenImageViewer extends StatelessWidget {
  final String imagePath;
  final String? heroTag;

  const FullscreenImageViewer({
    super.key,
    required this.imagePath,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Hero(
            tag: heroTag ?? imagePath,
            child: imagePath.startsWith('http://') || imagePath.startsWith('https://')
                ? Image.network(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        color: Colors.white,
                        size: 64,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                  )
                : Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        color: Colors.white,
                        size: 64,
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

