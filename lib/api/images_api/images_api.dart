import 'package:cloudinary/cloudinary.dart';
import 'package:ortho_waiting_list/api/images_api/exceptions/upload_exception.dart';
import 'package:ortho_waiting_list/models/case_image.dart';

class ImagesApi {
  ImagesApi._() {
    _cloudinary ??= Cloudinary.signedConfig(
      cloudName: const String.fromEnvironment('CLOUDINARY_NAME'),
      apiKey: const String.fromEnvironment('CLOUDINARY_API_KEY'),
      apiSecret: const String.fromEnvironment('CLOUDINARY_API_SECRET'),
    );
  }

  static ImagesApi get instance => ImagesApi._();

  static Cloudinary? _cloudinary;

  Future<CaseImage?> uploadImage(String case_id, List<int> fileBytes) async {
    final response = await _cloudinary!.unsignedUpload(
      fileBytes: fileBytes,
      resourceType: CloudinaryResourceType.image,
      uploadPreset: 'default',
    );
    if (response.error != null) {
      throw UploadException('${response.error}');
    }
    return CaseImage(
      id: '',
      case_id: case_id,
      image_url: response.url!,
      image_public_id: response.publicId!,
    );
  }

  Future<void> deleteImage(CaseImage caseImage) async {
    await _cloudinary!.destroy(
      caseImage.image_public_id,
      url: caseImage.image_url,
      resourceType: CloudinaryResourceType.image,
    );
  }
}
