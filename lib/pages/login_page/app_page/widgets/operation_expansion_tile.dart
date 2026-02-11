import 'package:flutter/material.dart';
import 'package:ortho_waiting_list/api/rank_api/rank_api.dart';
import 'package:ortho_waiting_list/api/specialities_api/spec_api.dart';
import 'package:ortho_waiting_list/components/prompt_dialog.dart';
import 'package:ortho_waiting_list/pages/login_page/app_page/widgets/images_control_row.dart';
import 'package:provider/provider.dart';
import 'package:ortho_waiting_list/api/doctors/doctors_api.dart';
import 'package:ortho_waiting_list/functions/shell_function.dart';
import 'package:ortho_waiting_list/models/doctor.dart';
import 'package:ortho_waiting_list/models/operation_expanded.dart';
import 'package:ortho_waiting_list/pages/login_page/app_page/widgets/consultant_picker_dialog.dart';
import 'package:ortho_waiting_list/providers/px_constants.dart';
import 'package:ortho_waiting_list/providers/px_operations.dart';
import 'package:ortho_waiting_list/providers/px_theme.dart';
import 'package:web/web.dart' as web;

class OperationExpansionTile extends StatelessWidget {
  const OperationExpansionTile({super.key, required this.operation});
  final OperationExpanded operation;

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxOperations, PxTheme>(
      builder: (context, o, t, _) {
        while (o.operations == null) {
          return const SizedBox(
            height: 15,
            child: LinearProgressIndicator(),
          );
        }
        return Card.outlined(
          elevation: 4,
          child: ExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
            ),
            backgroundColor:
                t.isDark ? Colors.amber.shade900 : Colors.amber.shade400,
            collapsedBackgroundColor:
                t.isDark ? Colors.green.shade900 : Colors.green.shade400,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Card.outlined(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(operation.rank.rank),
                      ),
                    ),
                    Card.outlined(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(operation.subspeciality.name),
                      ),
                    ),
                  ],
                ),
                Text(operation.name),
                Row(
                  children: [
                    Text(operation.phone),
                    const Spacer(),
                    IconButton.outlined(
                      onPressed: () {
                        web.window.open('tel:+2${operation.phone}', '_blank');
                      },
                      icon: const Icon(Icons.phone),
                    ),
                  ],
                ),
                Text(operation.diagnosis),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Text(operation.operation),
                Row(
                  spacing: 4,
                  children: [
                    const Text('اضافة بواسطة'),
                    const Text(' : '),
                    const Text('د / '),
                    Text(operation.added_by.name),
                  ],
                ),
              ],
            ),
            childrenPadding: const EdgeInsets.symmetric(
              vertical: 4,
            ),
            children: [
              ListTile(
                subtitle: const Divider(),
                title: Row(
                  children: [
                    const Text('الاستشاري'),
                    const Text(' : '),
                    const Text('د / '),
                    Text(
                      operation.consultant.name,
                    ),
                    const Spacer(),
                    FloatingActionButton.small(
                      tooltip: 'تغيير الاستشاري',
                      onPressed: () async {
                        final _consultant = await showDialog<Doctor?>(
                          context: context,
                          builder: (context) {
                            return ChangeNotifierProvider(
                              create: (context) => PxConstants(
                                doctors_api: const DoctorsApi(),
                                ranks_api: const RankApi(),
                                spec_api: const SpecApi(),
                              ),
                              child: const ConsultantPickerDialog(),
                            );
                          },
                        );
                        if (_consultant == null) {
                          return;
                        }
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await o.changeConsultant(
                                operation.id,
                                _consultant.id,
                              );
                            },
                          );
                        }
                      },
                      child: const Icon(Icons.compare_arrows_outlined),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              ListTile(
                subtitle: const Divider(),
                title: Row(
                  children: [
                    const Text('الحضور'),
                    const Text(' : '),
                    Icon(
                      operation.attended ? Icons.check : Icons.close,
                      size: 42,
                      color: operation.attended ? Colors.green : Colors.red,
                    ),
                    const Spacer(),
                    FloatingActionButton.small(
                      tooltip: 'تعديل الحضور',
                      onPressed: () async {
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await o.updateAttendance(operation);
                          },
                        );
                      },
                      child: const Icon(
                        Icons.person_add,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              ListTile(
                subtitle: const Divider(),
                title: Row(
                  children: [
                    const Text('التاجيل'),
                    const Text(' : '),
                    Text(operation.postponed.toString()),
                    const Spacer(),
                    FloatingActionButton.small(
                      tooltip: 'تغيير الموعد',
                      onPressed: () async {
                        final _operativeDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(
                              days: 365,
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
                              await o.rescheduleOperation(
                                operation,
                                _operativeDate,
                              );
                            },
                          );
                        }
                      },
                      child: const Icon(Icons.calendar_month),
                    ),
                    const SizedBox(width: 10),
                    FloatingActionButton.small(
                      tooltip: 'الغاء الموعد',
                      onPressed: () async {
                        final _toDeleteDate = await showDialog<bool?>(
                          context: context,
                          builder: (context) {
                            return const PromptDialog(
                              message: 'برجاء تاكيد الغاء الموعد ؟',
                            );
                          },
                        );
                        if (_toDeleteDate == null || _toDeleteDate == false) {
                          return;
                        }
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await o.deletescheduleForOperation(operation);
                            },
                          );
                        }
                      },
                      child: const Icon(Icons.event_busy),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              ImagesControlRow(operationExpanded: operation),
            ],
          ),
        );
      },
    );
  }
}
