import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/callapi.dart';
import 'package:flutter_application_1/model/favorite_service.dart';
import 'package:flutter_application_1/model/product.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final MakeupAPI api;

  const ProductDetailScreen({
    Key? key,
    required this.product,
    required this.api,
  }) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProductDetails();
  }

  Future<void> loadProductDetails() async {
    try {
      // ใช้ข้อมูลจาก Product แทนการเรียก API ใหม่
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading product details: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load product details. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFFD4A6B9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Consumer<FavoriteService>(
            builder: (context, favoriteService, child) {
              final isFavorite =
                  favoriteService.isProductInFavorites(widget.product);

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  favoriteService.toggleFavorite(widget.product);
                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4A6B9)),
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 60, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: TextStyle(fontSize: 16, color: Colors.red[700]),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () => loadProductDetails(),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFD4A6B9),
                        ),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 300,
                        color: const Color(0xFFF8E1EB),
                        child: widget.product.image.isNotEmpty
                            ? Image.network(
                                widget.product.image,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.image_not_supported,
                                        size: 80, color: Colors.grey),
                                  );
                                },
                              )
                            : const Center(
                                child: Icon(Icons.image_not_supported,
                                    size: 80, color: Colors.grey),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.product.brand,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '\$${widget.product.price}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD4A6B9),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.product.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Added to cart'),
                                      backgroundColor: Color(0xFFD4A6B9),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD4A6B9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 100, 2, 51),
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
