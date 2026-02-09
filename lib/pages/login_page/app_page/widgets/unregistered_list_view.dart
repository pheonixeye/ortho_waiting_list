import 'package:flutter/material.dart';
import 'package:ortho_waiting_list/components/central_error.dart';
import 'package:ortho_waiting_list/components/central_loading.dart';
import 'package:ortho_waiting_list/functions/shell_function.dart';
import 'package:ortho_waiting_list/models/_api_result.dart';
import 'package:ortho_waiting_list/models/doctor.dart';
import 'package:ortho_waiting_list/models/operation_dto.dart';
import 'package:ortho_waiting_list/models/rank.dart';
import 'package:ortho_waiting_list/models/speciality.dart';
import 'package:ortho_waiting_list/models/unreg_filter.dart';
import 'package:ortho_waiting_list/pages/login_page/app_page/widgets/create_new_operation_dto_dialog.dart';
import 'package:ortho_waiting_list/pages/login_page/app_page/widgets/unregistered_expansion_tile.dart';
import 'package:ortho_waiting_list/providers/px_constants.dart';
import 'package:ortho_waiting_list/providers/px_operations.dart';
import 'package:provider/provider.dart';

class UnregisteredListView extends StatelessWidget {
  const UnregisteredListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        key: UniqueKey(),
        child: const Icon(Icons.add),
        onPressed: () async {
          final _org = context.read<PxOperations>();
          final _operationUnreg = await showDialog<OperationDTO?>(
            context: context,
            builder: (context) {
              return const CreateNewOperationDtoDialog(
                operative_date: null,
              );
            },
          );
          if (_operationUnreg == null) {
            return;
          }
          if (context.mounted) {
            await shellFunction(
              context,
              toExecute: () async {
                await _org.createOperation(_operationUnreg);
              },
            );
          }
        },
      ),
      body: Consumer<PxOperations>(
        builder: (context, o, _) {
          while (o.unregistered == null) {
            return const CentralLoading();
          }
          while (o.unregistered is ApiErrorResult) {
            return CentralError(
              error: (o.unregistered as ApiErrorResult).originalErrorMessage,
              toExecute: o.init,
            );
          }
          // final _unregistered =
          //     (o.unregistered as ApiDataResult<List<OperationExpanded>>).data;
          return Column(
            spacing: 8,
            children: [
              Card.outlined(
                elevation: 6,
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('فلترة'),
                    ),
                    subtitle: Consumer<PxConstants>(
                      builder: (context, c, _) {
                        while (c.doctors == null ||
                            c.specs == null ||
                            c.ranks == null) {
                          return const SizedBox(
                            height: 10,
                            child: LinearProgressIndicator(),
                          );
                        }
                        final _doctors =
                            (c.doctors as ApiDataResult<List<Doctor>>).data;
                        final _ranks =
                            (c.ranks as ApiDataResult<List<Rank>>).data;
                        final _specs =
                            (c.specs as ApiDataResult<List<Speciality>>).data;
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 8,
                              children: [
                                ...UnregFilter.values.map((e) {
                                  return FilterChip(
                                    label: Text(e.ar),
                                    selected: o.filterType == e,
                                    selectedColor: Colors.amber,
                                    onSelected: (val) {
                                      o.selectFilter(e);
                                    },
                                  );
                                })
                              ],
                            ),
                            const SizedBox(height: 10),
                            switch (o.filterType) {
                              UnregFilter.all => const SizedBox(),
                              UnregFilter.rank => ConstrainedBox(
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
                                    initialValue: o.rankFilter,
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
                                        o.filterUnregBy(value.id);
                                      }
                                    },
                                  ),
                                ),
                              UnregFilter.spec => ConstrainedBox(
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
                                    initialValue: o.specFilter,
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
                                        o.filterUnregBy(value.id);
                                      }
                                    },
                                  ),
                                ),
                              UnregFilter.doctor => ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxHeight: 100),
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
                                          child: Text(doc.name),
                                        );
                                      })
                                    ],
                                    initialValue: o.docFilter,
                                    onChanged: (value) {
                                      if (value != null) {
                                        o.filterUnregBy(value.id);
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'اختر الاستشاري',
                                    ),
                                  ),
                                ),
                            }
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  cacheExtent: 3000,
                  itemCount: o.filteredUnreg.length,
                  itemBuilder: (context, index) {
                    final item = o.filteredUnreg[index];
                    return UnregisteredExpansionTile(
                      unregistered: item,
                      index: index,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
