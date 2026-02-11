import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ortho_waiting_list/api/images_api/images_api.dart';
import 'package:ortho_waiting_list/components/main_snackbar.dart';
import 'package:ortho_waiting_list/components/prompt_dialog.dart';
import 'package:ortho_waiting_list/functions/shell_function.dart';
import 'package:ortho_waiting_list/models/case_image.dart';
import 'package:ortho_waiting_list/models/operation_expanded.dart';
import 'package:ortho_waiting_list/pages/login_page/app_page/widgets/image_source_selector_dialog.dart';
import 'package:ortho_waiting_list/pages/login_page/app_page/widgets/image_view_dialog.dart';
import 'package:ortho_waiting_list/providers/px_operations.dart';
import 'package:provider/provider.dart';

class ImagesControlRow extends StatelessWidget {
  const ImagesControlRow({
    super.key,
    required this.operationExpanded,
  });
  final OperationExpanded operationExpanded;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          const Text('صور الاشاعات'),
          const Spacer(),
          FloatingActionButton.small(
            heroTag: UniqueKey(),
            tooltip: "اضافة اشاعات او صور للحالة",
            onPressed: () async {
              //todo: add images
              final _picker = ImagePicker();
              final _pxO = context.read<PxOperations>();
              CaseImage? _caseImage;

              final _imageSource = await showDialog<ImageSource?>(
                context: context,
                builder: (context) {
                  return ImageSourceSelectorDialog();
                },
              );
              if (_imageSource == null) {
                //todo: show no image source selected
                if (context.mounted) {
                  showInfoSnackbar(context, 'لم يتم اختيار مصدر الصورة');
                }
                return;
              }

              final _file = await _picker.pickImage(
                source: _imageSource,
              );

              if (_file == null) {
                //todo: show no file is picked
                if (context.mounted) {
                  showInfoSnackbar(context, 'لم يتم اختيار الصورة');
                }
                return;
              }

              final _fileBytes = await _file.readAsBytes();

              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    _caseImage = await ImagesApi.instance
                        .uploadImage(operationExpanded.id, _fileBytes);
                  },
                  progressMessage: 'جاري رفع الصورة',
                  duration: const Duration(milliseconds: 700),
                );
              }

              if (_caseImage == null) {
                //todo: show error
                if (context.mounted) {
                  showInfoSnackbar(context, 'خطأ في رفع الصورة');
                }
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await _pxO.addImageToOperation(
                      operationExpanded: operationExpanded,
                      caseImage: _caseImage!,
                    );
                  },
                );
              }
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10),
        ],
      ),
      subtitle: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            //todo: view images
            ...operationExpanded.images_ids.map((caseImage) {
              return SizedBox(
                width: 250,
                height: 350,
                child: Card.outlined(
                  elevation: 6,
                  color: Colors.brown.shade200,
                  child: InkWell(
                    onTap: () async {
                      await showDialog<void>(
                        context: context,
                        builder: (context) {
                          return ImageViewDialog(
                            url: caseImage.image_url,
                          );
                        },
                      );
                    },
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Align(
                          alignment: AlignmentGeometry.center,
                          child: CachedNetworkImage(
                            imageUrl: caseImage.image_url,
                            progressIndicatorBuilder: (context, url, progress) {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: progress.progress,
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: AlignmentGeometry.bottomCenter,
                          child: FloatingActionButton.small(
                            heroTag: UniqueKey(),
                            tooltip: 'الغاء الصورة',
                            onPressed: () async {
                              final _pxO = context.read<PxOperations>();

                              final _toDelete = await showDialog<bool?>(
                                context: context,
                                builder: (context) {
                                  return const PromptDialog(
                                      message: 'برجاء تاكيد الغاء الصورة ؟');
                                },
                              );

                              if (_toDelete == null || _toDelete == false) {
                                return;
                              }
                              if (context.mounted) {
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await ImagesApi.instance
                                        .deleteImage(caseImage);
                                    await _pxO.removeImageFromOperation(
                                      operationExpanded: operationExpanded,
                                      caseImage: caseImage,
                                    );
                                  },
                                );
                              }
                            },
                            child: const Icon(Icons.delete_forever),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
