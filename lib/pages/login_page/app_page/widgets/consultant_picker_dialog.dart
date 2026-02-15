import 'package:flutter/material.dart';
import 'package:ortho_waiting_list/extensions/is_mobile.dart';
import 'package:provider/provider.dart';
import 'package:ortho_waiting_list/components/central_error.dart';
import 'package:ortho_waiting_list/components/central_loading.dart';
import 'package:ortho_waiting_list/models/_api_result.dart';
import 'package:ortho_waiting_list/models/doctor.dart';
import 'package:ortho_waiting_list/providers/px_constants.dart';

class ConsultantPickerDialog extends StatefulWidget {
  const ConsultantPickerDialog({super.key});

  @override
  State<ConsultantPickerDialog> createState() => _ConsultantPickerDialogState();
}

class _ConsultantPickerDialogState extends State<ConsultantPickerDialog> {
  Doctor? _doc;
  @override
  Widget build(BuildContext context) {
    return Consumer<PxConstants>(
      builder: (context, d, _) {
        while (d.doctors == null) {
          return const CentralLoading();
        }
        while (d.doctors is ApiErrorResult) {
          return CentralError(
            error: (d.doctors as ApiErrorResult).originalErrorMessage,
            toExecute: d.init,
          );
        }
        final _doctors = (d.doctors as ApiDataResult<List<Doctor>>).data;
        return AlertDialog(
          title: Row(
            children: [
              const Text('اختر الاستشاري'),
              const Spacer(),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(2),
          insetPadding: const EdgeInsets.all(2),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
          shadowColor: Colors.amber.shade50,
          content: SizedBox(
            width: context.isMobile
                ? MediaQuery.sizeOf(context).width - 50
                : MediaQuery.sizeOf(context).width / 2,
            child: RadioGroup(
              groupValue: _doc,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _doc = value;
                });
                Navigator.pop(context, _doc);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView(
                      cacheExtent: 3000,
                      children: [
                        ..._doctors.map((doc) {
                          return Card.outlined(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RadioListTile(
                                title: Text(doc.name),
                                subtitle: Row(
                                  spacing: 8,
                                  children: [
                                    ...doc.speciality.map(
                                      (e) {
                                        final _index =
                                            doc.speciality.indexOf(e);
                                        if (_index >=
                                            doc.speciality.length - 1) {
                                          return Text(e.name);
                                        } else {
                                          return Text('${e.name} -');
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                value: doc,
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
