import 'package:flutter/material.dart';
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
          contentPadding: const EdgeInsets.all(2),
          insetPadding: const EdgeInsets.all(2),
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
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
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
                        value: doc,
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
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        );
      },
    );
  }
}
