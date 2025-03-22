import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/callapi.dart';
import 'package:flutter_application_1/model/product.dart';
import 'package:flutter_application_1/screen/favorite_screen.dart';
import 'package:flutter_application_1/screen/product_detail_screen.dart';
import 'package:flutter_application_1/screen/setting_screen.dart';
import 'package:flutter_application_1/screen/profile_screen.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int selectedTabIndex = 0;
  final MakeupAPI api = MakeupAPI();
  List<Product> products = [];
  bool isLoading = true;
  String searchQuery = '';
  String? errorMessage;
  
  // Add list of available tags for filtering
  final List<String> availableTags = [
    'Canadian', 'CertClean', 'Chemical Free', 'Dairy Free', 'EWG Verified',
    'EcoCert', 'Fair Trade', 'Gluten Free', 'Hypoallergenic', 'Natural',
    'No Talc', 'Non-GMO', 'Organic', 'Peanut Free Product', 'Sugar Free',
    'USDA Organic', 'Vegan', 'alcohol free', 'cruelty free', 'oil free',
    'purpicks', 'silicone free', 'water free'
  ];
  
  // Selected tags for filtering
  List<String> selectedTags = [];
  

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  // Updated loadProducts() to include tag filtering
  Future<void> loadProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      print('Fetching products with query: $searchQuery and tags: $selectedTags');
      final fetchedProducts = await api.fetchProducts(query: searchQuery);

      if (fetchedProducts.isNotEmpty) {
        List<Product> productModels = fetchedProducts
            .map<Product>((apiProduct) => Product.fromApi(apiProduct))
            .toList();
            
        // Apply tag filtering if tags are selected
        if (selectedTags.isNotEmpty) {
          productModels = productModels.where((product) {
            // Check if product has any of the selected tags
            return selectedTags.any((tag) => 
              product.tagList != null && 
              product.tagList.contains(tag.toLowerCase()));
          }).toList();
        }

        setState(() {
          products = productModels;
          isLoading = false;
        });
        print('Successfully loaded ${products.length} products');
      } else {
        setState(() {
          products = [];
          isLoading = false;
          errorMessage = searchQuery.isEmpty && selectedTags.isEmpty
              ? 'No products found.'
              : 'No products found for your search criteria.';
        });
      }
    } catch (e) {
      print('Error loading products: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load products. Please check your connection.';
      });
    }
  }

  void searchProducts(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
    loadProducts();
  }
  
  // Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Filter by Tags',
                style: TextStyle(
                  color: Color(0xFFD4A6B9),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Container(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: availableTags.map((tag) {
                          final isSelected = selectedTags.contains(tag);
                          return FilterChip(
                            label: Text(tag),
                            selected: isSelected,
                            selectedColor: Color(0xFFF8E1EB),
                            checkmarkColor: Color(0xFFD4A6B9),
                            labelStyle: TextStyle(
                              color: isSelected ? Color(0xFFD4A6B9) : Colors.black87,
                            ),
                            onSelected: (bool selected) {
                              setDialogState(() {
                                if (selected) {
                                  selectedTags.add(tag);
                                } else {
                                  selectedTags.remove(tag);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Clear All',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    setDialogState(() {
                      selectedTags.clear();
                    });
                  },
                ),
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
                    foregroundColor: const Color.fromARGB(255, 124, 4, 58)
                  ),
                  child: Text('Apply'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    loadProducts(); // Reload products with current filters
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }

  // Fixed navigation function
  void _navigateToScreen(String screenName) {
    Widget screen;
    
    switch (screenName) {
      case 'Favorites':
        screen = FavoritesScreen(api: api,);
        break;
      case 'Setting':
        screen = SettingScreen();
        break;
      case 'Profile':
        screen = ProfileScreen();
        break;
      default:
        return; // หากเป็น Home ไม่ต้องนำทางเพราะอยู่ที่หน้านี้แล้ว
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Color(0xFFD4A6B9),
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(255, 254, 254, 254),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 231, 242),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey, size: 26),
                        hintText: 'Search',
                        hintStyle: TextStyle(fontSize: 16),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: (value) {
                        searchProducts(value);
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // Updated filter button to show dialog when pressed
                GestureDetector(
                  onTap: _showFilterDialog,
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: selectedTags.isNotEmpty 
                          ? Color(0xFFD4A6B9) 
                          : const Color.fromARGB(255, 236, 154, 182),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.tune, color: Colors.white, size: 26),
                        if (selectedTags.isNotEmpty)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                selectedTags.length.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Show active filters if any
          if (selectedTags.isNotEmpty)
            Container(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ...selectedTags.map((tag) {
                    return Container(
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFFF8E1EB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xFFD4A6B9)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tag,
                            style: TextStyle(color: Color(0xFFD4A6B9)),
                          ),
                          SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedTags.remove(tag);
                                loadProducts();
                              });
                            },
                            child: Icon(
                              Icons.close, 
                              size: 16, 
                              color: Color(0xFFD4A6B9)
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  if (selectedTags.length > 1)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedTags.clear();
                          loadProducts();
                        });
                      },
                      child: Text(
                        "Clear All",
                        style: TextStyle(color: Colors.red[300]),
                      ),
                    ),
                ],
              ),
            ),

          // Category tabs
          Container(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryTab("All", 0),
                _buildCategoryTab("Libstick", 1),
                _buildCategoryTab("Mascara", 2),
                _buildCategoryTab("Blush", 3),
                _buildCategoryTab("Eyeliner", 4)
              ],
            ),
          ),

          // Popular header and See all
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // ฟังก์ชันสำหรับดูทั้งหมด
                  },
                  child: Text(
                    "See all",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product grid
          Expanded(
            child: Builder(
              builder: (context) {
                if (isLoading) {
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFD4A6B9)),
                  ));
                } else if (errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            errorMessage!,
                            style: TextStyle(fontSize: 16, color: Colors.red[700]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextButton(
                          onPressed: () => loadProducts(),
                          child: Text('Try Again'),
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFD4A6B9),
                            textStyle: TextStyle(fontSize: 16)
                          ),
                        )
                      ],
                    ),
                  );
                } else if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hourglass_empty, size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No products available.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                } else {
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildProductCard(product);
                    },
                  );
                }
              },
            ),
          ),

          // Bottom navigation
          Container(
            height: 65,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 227, 119, 161),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 10,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, "Home", true),
                _buildNavItem(Icons.favorite_border, "Favorites", false),
                _buildNavItem(Icons.settings, "Setting", false),
                _buildNavItem(Icons.person, "Profile", false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String title, int index) {
    bool isSelected = selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;

          // แก้ไข category ให้ตรงกับ API
          switch (index) {
            case 0:
              searchQuery = '';  // ทั้งหมด
              break;
            case 1:
              searchQuery = 'libstick';
              break;
            case 2:
              searchQuery = 'mascara';  // เปลี่ยนจาก bodycare เป็น body
              break;
            case 3:
              searchQuery = 'blush';  // เปลี่ยนจาก haircare เป็น hair
              break;
            case 4:
              searchQuery = 'eyeliner';  // เปลี่ยนจาก Moisturizing เป็น moisturizer
              break;
          }

          loadProducts();
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 214, 159, 179)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color.fromARGB(255, 192, 125, 158)),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? const Color.fromARGB(255, 255, 255, 255)
                  : const Color.fromARGB(255, 0, 0, 0),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
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
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / 
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
                          product.favorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Color(0xFFD4A6B9),
                          size: 24,
                        ),
                        onPressed: () {
                          setState(() {
                            product.favorite = !product.favorite;
                          });
                        },
                      ),
                    ),
                  ),
                  // Display tags/badges if product has them
                  if (product.tagList != null && product.tagList.isNotEmpty)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Color(0xFFD4A6B9).withOpacity(0.8),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.label, color: Colors.white, size: 12),
                            SizedBox(width: 2),
                            Text(
                              '${product.tagList.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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

  // Fixed _buildNavItem to use the corrected _navigateToScreen method
  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (label != "Home") {  // ไม่ต้องนำทางถ้าอยู่ที่หน้า Home อยู่แล้ว
          _navigateToScreen(label);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? const Color.fromARGB(255, 95, 0, 34)
                : const Color.fromARGB(255, 255, 255, 255),
            size: 28,
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color.fromARGB(255, 95, 0, 34)
                  : const Color.fromARGB(255, 255, 255, 255),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}