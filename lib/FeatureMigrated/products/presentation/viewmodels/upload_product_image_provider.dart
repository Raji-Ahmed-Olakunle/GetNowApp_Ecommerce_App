import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/upload_product_image.dart';

final uploadProductImageProvider = Provider((ref) => UploadProductImage()); 