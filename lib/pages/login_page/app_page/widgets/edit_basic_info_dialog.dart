import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ortho_waiting_list/components/central_error.dart';
import 'package:ortho_waiting_list/components/sm_btn.dart';
import 'package:ortho_waiting_list/extensions/is_mobile.dart';
import 'package:ortho_waiting_list/models/_api_result.dart';
import 'package:ortho_waiting_list/models/doctor.dart';
import 'package:ortho_waiting_list/models/operation_expanded.dart';
import 'package:ortho_waiting_list/models/rank.dart';
import 'package:ortho_waiting_list/models/speciality.dart';
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
  Doctor? _consultant;
  Speciality? _spec;

  String? _emptyFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'لا يمكن قبول ادخال فارغ';
    }
    return null;
  }

  String? _emptyDropdownValidator<T>(T? value) {
    if (value == null) {
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
    _spec = widget.operationExpanded.subspeciality;
    _consultant = widget.operationExpanded.consultant;
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
      title: Row(
        children: [
          const Text('تعديل البيانات'),
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
        child: Consumer<PxConstants>(
          builder: (context, c, _) {
            return Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView(
                      cacheExtent: 3000,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            spacing: 8,
                            children: [
                              SmBtn(),
                              Text(
                                'الاسم',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _patientNameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText:
                                  'رباعي بالعربي بدون همزات او تاء مربوطة',
                            ),
                            validator: _emptyFieldValidator,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            spacing: 8,
                            children: [
                              SmBtn(),
                              Text(
                                'الرتبة',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            while (c.ranks == null) {
                              return const LinearProgressIndicator();
                            }
                            while (c.ranks is ApiErrorResult) {
                              return CentralError(
                                error: (c.ranks as ApiErrorResult)
                                    .originalErrorMessage,
                                toExecute: c.init,
                              );
                            }
                            final _ranks =
                                (c.ranks as ApiDataResult<List<Rank>>).data;
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
                          child: Row(
                            spacing: 8,
                            children: [
                              SmBtn(),
                              Text(
                                'رقم الموبايل',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                          child: Row(
                            spacing: 8,
                            children: [
                              SmBtn(),
                              Text(
                                'التشخيص',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                          child: Row(
                            spacing: 8,
                            children: [
                              SmBtn(),
                              Text(
                                'العملية',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                          child: Row(
                            spacing: 8,
                            children: [
                              SmBtn(),
                              Text(
                                'نوع الحجز',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            while (c.specs == null) {
                              return const LinearProgressIndicator();
                            }
                            while (c.specs is ApiErrorResult) {
                              return CentralError(
                                error: (c.specs as ApiErrorResult)
                                    .originalErrorMessage,
                                toExecute: c.init,
                              );
                            }
                            final _specs =
                                (c.specs as ApiDataResult<List<Speciality>>)
                                    .data;
                            return Padding(
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
                                  validator: _emptyDropdownValidator,
                                ),
                              ),
                            );
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            spacing: 8,
                            children: [
                              SmBtn(),
                              Text(
                                'الاستشاري',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            while (c.doctors == null) {
                              return const LinearProgressIndicator();
                            }
                            while (c.doctors is ApiErrorResult) {
                              return CentralError(
                                error: (c.doctors as ApiErrorResult)
                                    .originalErrorMessage,
                                toExecute: c.init,
                              );
                            }
                            final _doctors =
                                (c.doctors as ApiDataResult<List<Doctor>>).data;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField<Doctor>(
                                hint: const Text(
                                  'اختر الاستشاري',
                                  textAlign: TextAlign.center,
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                alignment: Alignment.center,
                                isExpanded: true,
                                items: [
                                  ..._doctors.map((doc) {
                                    return DropdownMenuItem<Doctor>(
                                      value: doc,
                                      alignment: Alignment.center,
                                      child: Text.rich(
                                        TextSpan(
                                          text: doc.name,
                                          children: [
                                            const TextSpan(text: ' : '),
                                            const TextSpan(text: '('),
                                            ...doc.speciality.map((e) {
                                              final _index =
                                                  doc.speciality.indexOf(e);
                                              if (_index >=
                                                  doc.speciality.length - 1) {
                                                return TextSpan(text: e.name);
                                              }
                                              return TextSpan(
                                                  text: '${e.name}, ');
                                            }),
                                            const TextSpan(text: ')'),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                                ],
                                initialValue: _consultant,
                                onChanged: (value) {
                                  setState(() {
                                    _consultant = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'اختر الاستشاري',
                                ),
                                validator: _emptyDropdownValidator,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
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
                  consultant: _consultant,
                  subspeciality: _spec,
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
