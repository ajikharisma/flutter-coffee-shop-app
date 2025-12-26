import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // ================= AUTH =================
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('user_name', data['user']['name'] ?? 'User');
      return true;
    }
    return false;
  }

  static Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return response.statusCode == 201;
  }

  static Future<bool> resetPassword(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return response.statusCode == 200;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ================= PRODUCTS =================
  static Future<List<Product>> getProducts() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil produk');
    }
  }

  static Future<bool> createProduct({
    required String name,
    required String price,
    required String category,
    String? description,
    File? imageFile,
  }) async {
    final token = await getToken();
    var uri = Uri.parse('$baseUrl/products');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = name;
    request.fields['price'] = price;
    request.fields['category'] = category;
    request.fields['description'] = description ?? '';

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }

    var response = await request.send();
    return response.statusCode == 201;
  }

  static Future<bool> updateProduct({
    required int id,
    required String name,
    required String price,
    required String category,
    String? description,
    File? imageFile,
  }) async {
    final token = await getToken();
    var uri = Uri.parse('$baseUrl/products/$id');
    var request = http.MultipartRequest('POST', uri); // Laravel PUT via _method
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['_method'] = 'PUT';
    request.fields['name'] = name;
    request.fields['price'] = price;
    request.fields['category'] = category;
    request.fields['description'] = description ?? '';

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }

    var response = await request.send();
    return response.statusCode == 200;
  }

  static Future<bool> deleteProduct(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200;
  }
}






