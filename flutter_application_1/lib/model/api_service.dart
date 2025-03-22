import 'package:flutter_application_1/model/product.dart';

abstract class ApiService {
  Future<List<Product>> fetchProducts();
}
