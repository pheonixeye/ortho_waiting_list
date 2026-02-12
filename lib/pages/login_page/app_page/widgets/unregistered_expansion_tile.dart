import 'package:flutter/material.dart';
import 'package:ortho_waiting_list/extensions/number_translator.dart';
import 'package:ortho_waiting_list/functions/shell_function.dart';
import 'package:ortho_waiting_list/models/operation_expanded.dart';
import 'package:ortho_waiting_list/pages/login_page/app_page/widgets/edit_basic_info_dialog.dart';
import 'package:ortho_waiting_list/pages/login_page/app_page/widgets/images_control_row.dart';
import 'package:ortho_waiting_list/providers/px_operations.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as w;

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
              FloatingActionButton.small(
                tooltip: 'اتصال',
                heroTag: UniqueKey(),
                onPressed: () {
                  w.window.open('tel://+2${unregistered.phone}', '_blank');
                },
                child: const Icon(Icons.phone),
              ),
              const SizedBox(width: 10),
              FloatingActionButton.small(
                tooltip: 'تعديل البيانات',
                heroTag: UniqueKey(),
                onPressed: () async {
                  //todo
                  final o = context.read<PxOperations>();
                  final _updatedOperation =
                      await showDialog<OperationExpanded?>(
                    context: context,
                    builder: (context) {
                      return EditBasicInfoDialog(
                        operationExpanded: unregistered,
                      );
                    },
                  );
                  if (_updatedOperation == null) {
                    return;
                  }

                  if (context.mounted) {
                    await shellFunction(
                      context,
                      toExecute: () async {
                        await o.updateBasicOperationInfo(_updatedOperation);
                      },
                    );
                  }
                },
                child: const Icon(Icons.edit),
              ),
              const SizedBox(width: 10),
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
            ImagesControlRow(operationExpanded: unregistered),
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
