import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ortho_waiting_list/api/images_api/images_api.dart';
import 'package:ortho_waiting_list/extensions/number_translator.dart';
import 'package:ortho_waiting_list/functions/shell_function.dart';
import 'package:ortho_waiting_list/models/operation_expanded.dart';
import 'package:ortho_waiting_list/pages/login_page/app_page/widgets/image_source_selector_dialog.dart';
import 'package:ortho_waiting_list/providers/px_operations.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as w;
import 'package:universal_io/universal_io.dart' as io;

class UnregisteredExpansionTile extends StatelessWidget {
  const UnregisteredExpansionTile({
    super.key,
    required this.unregistered,
    required this.index,
  });
  final OperationExpanded unregistered;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          backgroundColor: Colors.amber.shade300,
          collapsedBackgroundColor: Colors.blue.shade300,
          title: Row(
            children: [
              FloatingActionButton.small(
                onPressed: null,
                heroTag: UniqueKey(),
                child: Text('${index + 1}'.toArabicNumber()),
              ),
              Card.outlined(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    unregistered.rank.rank,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(unregistered.name),
              ),
              const Spacer(),
              IconButton.outlined(
                onPressed: () {
                  w.window.open('tel://+2${unregistered.phone}', '_blank');
                },
                icon: const Icon(Icons.phone),
              ),
              const SizedBox(width: 10)
            ],
          ),
          subtitle: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Card.outlined(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          unregistered.diagnosis,
                        ),
                      ),
                    ),
                    Card.outlined(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          unregistered.operation,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Card.outlined(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          unregistered.subspeciality.name,
                        ),
                      ),
                    ),
                    Card.outlined(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          unregistered.consultant.name,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
          children: [
            ListTile(
              title: Row(
                children: [
                  const Text('صور الاشاعات'),
                  const Spacer(),
                  FloatingActionButton.small(
                    heroTag: UniqueKey(),
                    onPressed: () async {
                      //TODO: add images
                      final _picker = ImagePicker();
                      final _pxO = context.read<PxOperations>();

                      final _imageSource = await showDialog<ImageSource?>(
                        context: context,
                        builder: (context) {
                          return ImageSourceSelectorDialog();
                        },
                      );
                      if (_imageSource == null) {
                        //TODO: show no image source selected
                        return;
                      }

                      final _file = await _picker.pickImage(
                        source: _imageSource,
                      );

                      if (_file == null) {
                        //TODO: show no file is picked
                        return;
                      }

                      final _imagePublicId =
                          await ImagesApi.instance.uploadImage(_file.path);

                      if (_imagePublicId == null) {
                        //TODO: show error
                        return;
                      }
                      if (context.mounted) {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await _pxO.addImageToOperation(
                              operationId: unregistered.id,
                              imagePublicId: _imagePublicId,
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
                    //TODO: view images
                    ...[1, 2, 3, 4, 5, 6, 7, 8, 9, 0].map((i) {
                      return SizedBox(
                        width: 250,
                        height: 350,
                        child: Card.outlined(
                          elevation: 6,
                          color: Colors.brown.shade200,
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    //todo: Add schedule operation
                    final _pxO = context.read<PxOperations>();
                    final _operativeDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(
                        const Duration(
                          days: 800,
                        ),
                      ),
                    );
                    if (_operativeDate == null) {
                      return;
                    }

                    if (context.mounted) {
                      await shellFunction(
                        context,
                        toExecute: () async {
                          await _pxO.scheduleOperation(
                            unregistered.id,
                            _operativeDate,
                          );
                        },
                      );
                    }
                  },
                  label: const Text('تحديد موعد'),
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
