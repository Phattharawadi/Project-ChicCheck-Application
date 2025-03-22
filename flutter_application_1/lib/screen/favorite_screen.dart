import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/favorite_service.dart';
import 'package:flutter_application_1/model/product.dart';
import 'package:flutter_application_1/screen/product_detail_screen.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  final dynamic api;

  FavoritesScreen({Key? key, required this.api}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ใช้ Consumer แทน ChangeNotifierProvider เพื่อเรียกใช้ FavoriteService ที่มีอยู่แล้ว
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favorites',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Color(0xFFD4A6B9),
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(255, 254, 254, 254),
      body: Consumer<FavoriteService>(
        builder: (context, favoriteService, child) {
          final favorites = favoriteService.favorites;

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Color(0xFFD4A6B9).withOpacity(0.5),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on products you love',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${favorites.length} ${favorites.length == 1 ? 'item' : 'items'}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Clear All Favorites',
                                style: TextStyle(
                                  color: Color(0xFFD4A6B9),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                  'Are you sure you want to remove all items from your favorites?'),
                              actions: [
                                TextButton(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFD4A6B9),
                                  ),
                                  child: Text('Clear All'),
                                  onPressed: () {
                                    favoriteService.clearFavorites();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon:
                          Icon(Icons.delete_outline, color: Colors.red[300]),
                      label: Text(
                        'Clear All',
                        style: TextStyle(color: Colors.red[300]),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final product = favorites[index];
                    return _buildProductCard(
                        context, product, favoriteService);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    FavoriteService favoriteService,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: product,
              api: api,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF8E1EB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Container(
                      color: Color(0xFFF8E1EB),
                      width: double.infinity,
                      child: product.image.isNotEmpty &&
                              product.image.startsWith('http')
                          ? Image.network(
                              product.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(Icons.image_not_supported,
                                      size: 50, color: Colors.grey),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFD4A6B9)),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Icon(Icons.image_not_supported,
                                  size: 50, color: Colors.grey),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Color(0xFFD4A6B9),
                          size: 24,
                        ),
                        onPressed: () {
                          favoriteService.toggleFavorite(product);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    product.brand,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 153, 183),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18,
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
    );
  }
}