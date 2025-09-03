import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UploadProductImage {
  Future<String> call(File image) async {
    final imageBytes = await image.readAsBytes();
    final base64Image = base64Encode(imageBytes);
    final url = Uri.parse("https://api.imgbb.com/1/upload");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "key": dotenv.env['Api_key'],
        "image": base64Image,
      },
    );
    final data = json.decode(response.body);
    return data['data']['display_url'];
  }
} 