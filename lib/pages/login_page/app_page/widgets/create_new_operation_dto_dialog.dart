import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ortho_waiting_list/models/rank.dart';
import 'package:ortho_waiting_list/models/speciality.dart';
import 'package:provider/provider.dart';
import 'package:ortho_waiting_list/components/central_error.dart';
import 'package:ortho_waiting_list/components/central_loading.dart';
import 'package:ortho_waiting_list/extensions/number_translator.dart';
import 'package:ortho_waiting_list/models/_api_result.dart';
import 'package:ortho_waiting_list/models/doctor.dart';
import 'package:ortho_waiting_list/models/operation_dto.dart';
import 'package:ortho_waiting_list/providers/px_auth.dart';
import 'package:ortho_waiting_list/providers/px_constants.dart';

class CreateNewOperationDtoDialog extends StatefulWidget {
  const CreateNewOperationDtoDialog({
    super.key,
    required this.operative_date,
  });
  final DateTime? operative_date;

  @override
  State<CreateNewOperationDtoDialog> createState() =>
      _CreateNewOperationDtoDialogState();
}

class _CreateNewOperationDtoDialogState
    extends State<CreateNewOperationDtoDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _patientNameController;
  late final TextEditingController _patientPhoneController;
  late final TextEditingController _patientDiagnosisController;
  late final TextEditingController _patientOperationController;

  String? _consultant_id;
  Speciality? _spec;
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
    _patientNameController = TextEditingController();
    _patientPhoneController = TextEditingController();
    _patientDiagnosisController = TextEditingController();
    _patientOperationController = TextEditingController();
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
    return Consumer<PxConstants>(
      builder: (context, d, _) {
        while (d.doctors == null || d.ranks == null || d.specs == null) {
          return const CentralLoading();
        }
        while (d.doctors is ApiErrorResult) {
          return CentralError(
            error: (d.doctors as ApiErrorResult).originalErrorMessage,
            toExecute: d.init,
          );
        }

        final _doctors = (d.doctors as ApiDataResult<List<Doctor>>).data;
        final _ranks = (d.ranks as ApiDataResult<List<Rank>>).data;
        final _specs = (d.specs as ApiDataResult<List<Speciality>>).data;
        return AlertDialog(
          contentPadding: const EdgeInsets.all(2),
          insetPadding: const EdgeInsets.all(2),
          title: Row(
            children: [
              if (widget.operative_date == null)
                const Text('اضافة عملية')
              else
                Text(
                  'اضافة عملية ${widget.operative_date?.day} / ${widget.operative_date?.month} / ${widget.operative_date?.year}'
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'نوع الحجز',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 100,
                      ),
                      child: DropdownButtonFormField<Speciality>(
                        isExpanded: true,
                        alignment: Alignment.center,
                        hint: const Text(
                          'اختر نوع الحجز',
                          textAlign: TextAlign.center,
                        ),
                        initialValue: _spec,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          ..._specs.map((s) {
                            return DropdownMenuItem<Speciality>(
                              value: s,
                              alignment: Alignment.center,
                              child: Text(
                                s.name,
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _spec = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
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
                  Padding(
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
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'الاستشاري',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      hint: const Text(
                        'اختر الاستشاري',
                        textAlign: TextAlign.center,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      alignment: Alignment.center,
                      isExpanded: true,
                      items: [
                        ..._doctors.map((doc) {
                          return DropdownMenuItem<String>(
                            value: doc.id,
                            alignment: Alignment.center,
                            child: Text(doc.name),
                          );
                        })
                      ],
                      initialValue: _consultant_id,
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
                      rank: _rank?.id ?? '',
                      phone: _patientPhoneController.text,
                      diagnosis: _patientDiagnosisController.text,
                      operation: _patientOperationController.text,
                      consultant: _consultant_id ?? '',
                      added_by: context.read<PxAuth>().doc_id,
                      subspeciality: _spec?.id ?? '',
                      attended: false,
                      postponed: 0,
                      operative_date:
                          widget.operative_date?.toIso8601String() ?? '',
                      images_ids: const [],
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
