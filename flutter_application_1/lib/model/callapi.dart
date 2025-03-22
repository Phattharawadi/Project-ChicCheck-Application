
import 'dart:convert';
import 'package:http/http.dart' as http;

class MakeupAPI {
  // เปลี่ยน URL เป็น API endpoint ที่ถูกต้อง
  // ตัวอย่าง: API จาก Makeup API หรือ API ที่คุณต้องการใช้
  final String baseUrl = 'https://makeup-api.herokuapp.com/api/v1/products.json';
  
  Future<List<dynamic>> fetchProducts({String query = ''}) async {
    try {
      // สร้าง URL ที่ถูกต้องสำหรับการค้นหา
      final url = query.isEmpty 
          ? baseUrl 
          : '$baseUrl?product_type=$query';
      
      print('Calling API: $url');
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('API returned ${data.length} products');
        return data;
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception during API call: $e');
      return [];
    }
  }
  
  Future<Map<String, dynamic>?> fetchProductDetails(int productId) async {
    try {
      final url = '$baseUrl/$productId';
      print('Fetching product details: $url');
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load product details');
        return null;
      }
    } catch (e) {
      print('Exception during product details API call: $e');
      return null;
    }
  }
}

