import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:urology_waiting_list/components/central_error.dart';
import 'package:urology_waiting_list/components/central_loading.dart';
import 'package:urology_waiting_list/extensions/number_translator.dart';
import 'package:urology_waiting_list/models/_api_result.dart';
import 'package:urology_waiting_list/models/doctor.dart';
import 'package:urology_waiting_list/models/operation_dto.dart';
import 'package:urology_waiting_list/models/waiting_type.dart';
import 'package:urology_waiting_list/providers/px_auth.dart';
import 'package:urology_waiting_list/providers/px_doctors.dart';

class CreateNewOperationDtoDialog extends StatefulWidget {
  const CreateNewOperationDtoDialog({
    super.key,
    required this.operative_date,
  });
  final DateTime operative_date;

  @override
  State<CreateNewOperationDtoDialog> createState() =>
      _CreateNewOperationDtoDialogState();
}

class _CreateNewOperationDtoDialogState
    extends State<CreateNewOperationDtoDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _patientNameController;
  late final TextEditingController _patientRankController;
  late final TextEditingController _patientPhoneController;
  late final TextEditingController _patientDiagnosisController;
  late final TextEditingController _patientOperationController;

  String? _consultant_id;
  WaitingType? _type;

  String? _emptyFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'لا يمكن قبول ادخال فارغ';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _patientNameController = TextEditingController();
    _patientRankController = TextEditingController();
    _patientPhoneController = TextEditingController();
    _patientDiagnosisController = TextEditingController();
    _patientOperationController = TextEditingController();
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientRankController.dispose();
    _patientPhoneController.dispose();
    _patientDiagnosisController.dispose();
    _patientOperationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PxDoctors>(
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
              Text(
                'اضافة عملية ${widget.operative_date.day} / ${widget.operative_date.month} / ${widget.operative_date.year}'
                    .toArabicNumber(),
              ),
              const Spacer(),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          scrollable: true,
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('نوع الحجز'),
                    subtitle: FormField<WaitingType>(
                      builder: (field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ...WaitingType.values.map((type) {
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Builder(
                                        builder: (context) {
                                          bool _isSelected = _type == type;
                                          return Card.outlined(
                                            elevation: _isSelected ? 0 : 6,
                                            color: _isSelected
                                                ? Colors.amber
                                                : null,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RadioListTile(
                                                title: Text(type.ar),
                                                contentPadding:
                                                    const EdgeInsets.all(0),
                                                dense: true,
                                                value: type,
                                                groupValue: _type,
                                                onChanged: (val) {
                                                  setState(() {
                                                    _type = val;
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                })
                              ],
                            ),
                            if (!field.isValid)
                              Text(
                                field.errorText ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              )
                            else
                              const SizedBox(),
                          ],
                        );
                      },
                      validator: (value) {
                        if (_type == null) {
                          return 'اختر نوع الحجز عملية او تفتيت';
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('الاسم'),
                    subtitle: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _patientNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'رباعي بالعربي بدون همزات او تاء مربوطة',
                      ),
                      validator: _emptyFieldValidator,
                    ),
                  ),
                  ListTile(
                    title: const Text('الرتبة'),
                    subtitle: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _patientRankController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'مجند - امين شرطة - مساعد شرطة - ضابط شرف...',
                      ),
                      validator: _emptyFieldValidator,
                    ),
                  ),
                  ListTile(
                    title: const Text('رقم الموبايل'),
                    subtitle: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _patientPhoneController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'احد عشر رقم',
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length != 11) {
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
                  ListTile(
                    title: const Text('التشخيص'),
                    subtitle: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _patientDiagnosisController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'دوالي خصية - حصوة حالب...',
                      ),
                      validator: _emptyFieldValidator,
                    ),
                  ),
                  ListTile(
                    title: const Text('العملية'),
                    subtitle: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _patientOperationController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'منظار كلي - منظار مرن - ورم مثانة منظار...',
                      ),
                      validator: _emptyFieldValidator,
                    ),
                  ),
                  ListTile(
                    title: const Text('الاستشاري'),
                    subtitle: DropdownButtonFormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      alignment: Alignment.center,
                      items: [
                        ..._doctors.map((doc) {
                          return DropdownMenuItem<String>(
                            value: doc.id,
                            alignment: Alignment.center,
                            child: Text(doc.name),
                          );
                        })
                      ],
                      value: _consultant_id,
                      onChanged: (value) {
                        setState(() {
                          _consultant_id = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'اختر الاستشاري',
                      ),
                      validator: _emptyFieldValidator,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final data = OperationDTO(
                      id: '',
                      name: _patientNameController.text,
                      rank: _patientRankController.text,
                      phone: _patientPhoneController.text,
                      diagnosis: _patientDiagnosisController.text,
                      operation: _patientOperationController.text,
                      consultant: _consultant_id!,
                      added_by: context.read<PxAuth>().doc_id,
                      type: _type!.name,
                      attended: false,
                      postponed: 0,
                      operative_date: widget.operative_date.toIso8601String(),
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
      },
    );
  }
}
