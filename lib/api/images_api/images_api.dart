import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:ortho_waiting_list/api/images_api/exceptions/upload_exception.dart';
import 'package:universal_io/universal_io.dart' as io;

class ImagesApi {
  ImagesApi._() {
    _cloudinaryObject ??= CloudinaryObject.fromCloudName(
      cloudName: const String.fromEnvironment('CLOUDINARY_NAME'),
    );
    _cloudinary ??= Cloudinary.fromCloudName(
      cloudName: const String.fromEnvironment('CLOUDINARY_NAME'),
    );
  }

  static ImagesApi get instance => ImagesApi._();

  static CloudinaryObject? _cloudinaryObject;
  static CloudinaryObject? get cloudinaryObject => _cloudinaryObject;

  static Cloudinary? _cloudinary;

  Future<String?> uploadImage(String path) async {
    final response = await _cloudinary!.uploader().upload(
          io.File(path),
          params: UploadParams(
            uploadPreset: "default",
          ),
        );
    if (response?.error != null) {
      throw UploadException('${response?.error?.message}');
    }
    return '${response?.data?.publicId}';
  }
}
