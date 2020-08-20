

import 'dart:convert';
import 'dart:io';
import 'package:blocform/src/shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;

import 'package:blocform/src/models/product_model.dart';
import 'package:mime_type/mime_type.dart';

class ProductProvider {
  static final _prefs = new Preferences();

  final String baseUrl = 'https://flutterexample-cafea.firebaseio.com/';
  final String productsUrl = 'products.json?auth=${ _prefs.token }';
  final String deleteUrl = 'products';

  Future<bool> createProduct(Product product) async {
    final url = baseUrl + productsUrl;

    final resp = await http.post(url, body: productToJson(product));
  
    final decodedData = json.decode(resp.body);

    print (decodedData);

    return true;
  }

  Future<List<Product>> getProducts() async {
    final url = baseUrl + productsUrl;

    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<Product> products = new List();
    
    if(decodedData == null) return [];

    decodedData.forEach((key, value) {
      final prod = Product.fromJson(value);
      prod.id = key;
      products.add(prod);
    });

    return products;
  }

  Future<int> deleteProduct(String id) async {
    final url = '$baseUrl/products/$id.json';

    await http.delete(url);

    return 1;
  }

  Future<bool> updateProduct(Product product) async {
    final url = '$baseUrl/products/${product.id}.json?auth=${_prefs.token}';

    final resp = await http.put(url, body: productToJson(product));
  
    final decodedData = json.decode(resp.body);

    print (decodedData);

    return true;
  }

  Future<String> uploadImage (File image) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/flutterv1/image/upload?upload_preset=wxjo82io');
    final mimeType = mime(image.path).split('/');

    final req = http.MultipartRequest(
      'POST',
      uri
    );

    final file = await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType(mimeType[0], mimeType[1]));
      
      req.files.add(file);

      final streamResponse = await req.send();
      final resp = await http.Response.fromStream(streamResponse);

      if(resp.statusCode != 200 && resp.statusCode != 201) {
        print(resp.body);
        return null;
      }

      final respData = json.decode(resp.body);
      print( respData);
      
      return respData['secure_url'];
  }

}