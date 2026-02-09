import 'package:cloudinary_flutter/cloudinary_object.dart';

class ImagesApi {
  ImagesApi() {
    cloudinaryObject ??= CloudinaryObject.fromCloudName(
        cloudName: const String.fromEnvironment('CLOUDINARY_NAME'));
  }

  static CloudinaryObject? cloudinaryObject;

  Future<CldImage> uploadImage(String publicId) async {
    return cloudinaryObject?.image(publicId);
  }
}
