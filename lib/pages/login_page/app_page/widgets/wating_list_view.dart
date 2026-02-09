import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ortho_waiting_list/api/doctors/doctors_api.dart';
import 'package:ortho_waiting_list/api/rank_api/rank_api.dart';
import 'package:ortho_waiting_list/api/specialities_api/spec_api.dart';
import 'package:ortho_waiting_list/components/central_error.dart';
import 'package:ortho_waiting_list/components/central_loading.dart';
import 'package:ortho_waiting_list/components/main_snackbar.dart';
import 'package:ortho_waiting_list/extensions/date_ext.dart';
import 'package:ortho_waiting_list/extensions/number_translator.dart';
import 'package:ortho_waiting_list/functions/shell_function.dart';
import 'package:ortho_waiting_list/logic/date_provider.dart';
import 'package:ortho_waiting_list/models/_api_result.dart';
import 'package:ortho_waiting_list/models/operation_dto.dart';
import 'package:ortho_waiting_list/models/operation_expanded.dart';
import 'package:ortho_waiting_list/models/weekdays.dart';
import 'package:ortho_waiting_list/pages/login_page/app_page/widgets/create_new_operation_dto_dialog.dart';
import 'package:ortho_waiting_list/pages/login_page/app_page/widgets/operation_expansion_tile.dart';
import 'package:ortho_waiting_list/providers/px_constants.dart';
import 'package:ortho_waiting_list/providers/px_operations.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class WatingListView extends StatefulWidget {
  const WatingListView({super.key});

  @override
  State<WatingListView> createState() => _WatingListViewState();
}

class _WatingListViewState extends State<WatingListView> {
  final _dateProvider = WidgetsDateProvider();
  static const double _textWidth = 50;
  static const double _monthsWidth = 150;
  static const double _yearsWidth = 120;
  late final ItemScrollController _yearsController = ItemScrollController();
  late final ItemScrollController _monthsController = ItemScrollController();

  final _duration = const Duration(milliseconds: 750);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _yearsController.scrollTo(
        index: _dateProvider.years.indexOf(DateTime.now().year),
        duration: _duration,
        curve: Curves.fastOutSlowIn,
      );
      _monthsController.scrollTo(
        index: _dateProvider.months.keys.toList().indexOf(DateTime.now().month),
        duration: _duration,
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PxOperations>(
      builder: (context, o, _) {
        return Column(
          children: [
            SizedBox(
              height: _textWidth,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const SizedBox(
                    width: _textWidth,
                    child: Text("السنة"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ScrollablePositionedList.builder(
                      itemScrollController: _yearsController,
                      itemCount: _dateProvider.years.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final _year = _dateProvider.years[index];
                        final isSelected = _year == o.date.year;
                        return SizedBox(
                          width: _yearsWidth,
                          child: Card(
                            elevation: isSelected ? 0 : 10,
                            child: RadioMenuButton<int>(
                              value: _year,
                              groupValue: o.date.year,
                              onChanged: (value) async {
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await o.setDate(
                                      o.date.copyWith(
                                        year: value,
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(_year.toString().toArabicNumber()),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _textWidth,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const SizedBox(
                    width: _textWidth,
                    child: Text("الشهر"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ScrollablePositionedList.builder(
                      itemScrollController: _monthsController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _dateProvider.months.length,
                      itemBuilder: (context, index) {
                        final _month =
                            _dateProvider.months.entries.toList()[index];
                        bool isSelected = _month.key == o.date.month;

                        return SizedBox(
                          width: _monthsWidth,
                          child: Card(
                            elevation: isSelected ? 0 : 10,
                            child: RadioMenuButton<int>(
                              value: _month.key,
                              groupValue: o.date.month,
                              onChanged: (value) async {
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await o.setDate(
                                      o.date.copyWith(
                                        month: value,
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(_month.value),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  while (o.operations == null) {
                    return const CentralLoading();
                  }
                  while (o.operations is ApiErrorResult) {
                    return CentralError(
                      error:
                          (o.operations as ApiErrorResult).originalErrorMessage,
                      toExecute: o.init,
                    );
                  }

                  final _operations =
                      (o.operations as ApiDataResult<List<OperationExpanded>>)
                          .data;
                  return ListView(
                    cacheExtent: 3000,
                    children: [
                      ..._dateProvider.daysPerMonth(o.date.month).map((day) {
                        return Builder(
                          builder: (context) {
                            final _itemDate =
                                DateTime(o.date.year, o.date.month, day);
                            return Card.outlined(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: FloatingActionButton.small(
                                    onPressed: null,
                                    heroTag: UniqueKey(),
                                  ),
                                  contentPadding: const EdgeInsets.all(0),
                                  titleAlignment: ListTileTitleAlignment.top,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            text: DateFormat(
                                                    'dd / MM / yyyy', 'ar')
                                                .format(_itemDate),
                                            children: [
                                              const TextSpan(text: '\n'),
                                              TextSpan(
                                                text: _itemDate.weekday
                                                    .toArabicWeekdayString(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      FloatingActionButton.small(
                                        tooltip: 'اضافة موعد عملية',
                                        heroTag: UniqueKey(),
                                        onPressed: () async {
                                          if (DateTime.now()
                                              .isAfter(_itemDate)) {
                                            showInfoSnackbar(
                                              context,
                                              'لا يمكن اضافة موعد بتاريخ سابق',
                                            );
                                            return;
                                          }
                                          final _dto =
                                              await showDialog<OperationDTO?>(
                                            context: context,
                                            builder: (context) {
                                              return ChangeNotifierProvider(
                                                create: (context) =>
                                                    PxConstants(
                                                  doctors_api:
                                                      const DoctorsApi(),
                                                  ranks_api: const RankApi(),
                                                  spec_api: const SpecApi(),
                                                ),
                                                child:
                                                    CreateNewOperationDtoDialog(
                                                  operative_date: _itemDate,
                                                ),
                                              );
                                            },
                                          );
                                          if (_dto == null) {
                                            return;
                                          }
                                          if (context.mounted) {
                                            await shellFunction(
                                              context,
                                              toExecute: () async {
                                                await o.createOperation(_dto);
                                              },
                                            );
                                          }
                                        },
                                        child: const Icon(Icons.add),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                  subtitle: Column(
                                    spacing: 2,
                                    children: [
                                      ..._operations.map((operation) {
                                        if (operation.operative_date != null &&
                                            operation.operative_date!
                                                .isSameDate(_itemDate)) {
                                          return OperationExpansionTile(
                                            operation: operation,
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      })
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
