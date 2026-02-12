import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ortho_waiting_list/components/central_error.dart';
import 'package:ortho_waiting_list/models/_api_result.dart';
import 'package:ortho_waiting_list/models/operation_expanded.dart';
import 'package:ortho_waiting_list/models/rank.dart';
import 'package:ortho_waiting_list/providers/px_constants.dart';
import 'package:provider/provider.dart';

class EditBasicInfoDialog extends StatefulWidget {
  const EditBasicInfoDialog({
    super.key,
    required this.operationExpanded,
  });
  final OperationExpanded operationExpanded;

  @override
  State<EditBasicInfoDialog> createState() => _EditBasicInfoDialogState();
}

class _EditBasicInfoDialogState extends State<EditBasicInfoDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _patientNameController;
  late final TextEditingController _patientPhoneController;
  late final TextEditingController _patientDiagnosisController;
  late final TextEditingController _patientOperationController;
  Rank? _rank;

  String? _emptyFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'لا يمكن قبول ادخال فارغ';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _patientNameController =
        TextEditingController(text: widget.operationExpanded.name);
    _patientPhoneController =
        TextEditingController(text: widget.operationExpanded.phone);
    _patientDiagnosisController =
        TextEditingController(text: widget.operationExpanded.diagnosis);
    _patientOperationController =
        TextEditingController(text: widget.operationExpanded.operation);
    _rank = widget.operationExpanded.rank;
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientPhoneController.dispose();
    _patientDiagnosisController.dispose();
    _patientOperationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(2),
      insetPadding: const EdgeInsets.all(2),
      title: Row(
        children: [
          const Text('تعديل البيانات الاساسية'),
          const Spacer(),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'الاسم',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _patientNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'رباعي بالعربي بدون همزات او تاء مربوطة',
                ),
                validator: _emptyFieldValidator,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'الرتبة',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Consumer<PxConstants>(
              builder: (context, c, _) {
                while (c.ranks == null) {
                  return const LinearProgressIndicator();
                }
                while (c.ranks is ApiErrorResult) {
                  return CentralError(
                    error: (c.ranks as ApiErrorResult).originalErrorMessage,
                    toExecute: c.init,
                  );
                }
                final _ranks = (c.ranks as ApiDataResult<List<Rank>>).data;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 100,
                    ),
                    child: DropdownButtonFormField<Rank>(
                      hint: const Text(
                        'اختر الرتبة',
                        textAlign: TextAlign.center,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      alignment: Alignment.center,
                      initialValue: _rank,
                      items: [
                        ..._ranks.map((r) {
                          return DropdownMenuItem<Rank>(
                            value: r,
                            alignment: Alignment.center,
                            child: Text(
                              r.rank,
                            ),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _rank = value;
                          });
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'رقم الموبايل',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _patientPhoneController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'احد عشر رقم',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 11) {
                    return 'برجاء ادخال رقم صحيح';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'التشخيص',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _patientDiagnosisController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'ادخل التشخيص',
                ),
                validator: _emptyFieldValidator,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'العملية',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _patientOperationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'ادخل قرار الاستشاري',
                ),
                validator: _emptyFieldValidator,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final data = widget.operationExpanded.copyWith(
                  name: _patientNameController.text,
                  phone: _patientPhoneController.text,
                  diagnosis: _patientDiagnosisController.text,
                  operation: _patientOperationController.text,
                  rank: _rank,
                );
                Navigator.pop(context, data);
              }
            },
            label: const Text("حفظ"),
            icon: const Icon(Icons.save),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context, null);
            },
            label: const Text(
              "الغاء",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
