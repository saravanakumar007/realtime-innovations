import 'package:employee_list/consts/app_colors.dart';
import 'package:employee_list/consts/app_text_styles.dart';
import 'package:employee_list/presentation/widgets/custom_date_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class DialogDatePicker {
  DialogDatePicker({
    required this.compareDate,
    required this.buildContext,
    required this.onDateChanged,
    this.initiaDate,
    this.isEndDate = false,
  });
  final DateTime? compareDate;
  final bool isEndDate;
  final Function onDateChanged;
  final BuildContext buildContext;
  final DateTime? initiaDate;

  DateTime? selectedDate;
  bool hasDefaultDateTime = false;
  final ValueNotifier<int> valueNotifier = ValueNotifier(0);

  DateTime getNextDay() {
    return DateTime.now().add(const Duration(days: 1));
  }

  DateTime getNextDayAfterDay() {
    return DateTime.now().add(const Duration(days: 2));
  }

  DateTime getAfterOneWeek() {
    return DateTime.now().add(const Duration(days: 7));
  }

  Widget _textButton(String label, DateTime? date, {bool hasNoDate = false}) {
    bool isSelected = false;
    if (hasDefaultDateTime) {
      isSelected = (selectedDate!.year == date!.year &&
          selectedDate!.month == date.month &&
          selectedDate!.day == date.day);
    } else {
      isSelected = label == 'No Date' && date == null;
    }

    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              isSelected ? AppColors.primaryColor : AppColors.secondaryColor,
          foregroundColor: isSelected ? Colors.white : AppColors.primaryColor,
        ),
        onPressed: () {
          if (label == 'No Date') {
            hasDefaultDateTime = false;
          } else {
            hasDefaultDateTime = true;
            selectedDate = date;
          }
          valueNotifier.value = valueNotifier.value + 1;
        },
        child: Text(label),
      ),
    );
  }

  void showDialogDatePicker() {
    hasDefaultDateTime = initiaDate != null;
    selectedDate = initiaDate ?? DateTime.now();
    showDialog(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: kIsWeb
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.2,
                  vertical: 24.0)
              : EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          content: ValueListenableBuilder<int>(
            valueListenable: valueNotifier,
            builder: (context, value, child) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (hasDefaultDateTime) ...[
                      _textButton("Today", DateTime.now()),
                      const SizedBox(width: 20),
                      _textButton(
                          "Next ${DateFormat('EEEE').format(DateTime.now().add(const Duration(days: 1)))}",
                          getNextDay()),
                    ] else ...[
                      _textButton("No Date", null),
                      const SizedBox(width: 20),
                      _textButton("Today", DateTime.now()),
                    ]
                  ],
                ),
                if (kIsWeb) SizedBox(height: 20),
                if (hasDefaultDateTime) ...[
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _textButton(
                          "Next ${DateFormat('EEEE').format(DateTime.now().add(const Duration(days: 2)))}",
                          getNextDayAfterDay()),
                      const SizedBox(width: 20),
                      _textButton("After 1 week", getAfterOneWeek()),
                    ],
                  ),
                ],

                const SizedBox(height: 20),

                // Calendar Date Picker
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CustomDatePicker(
                    hasDefaultDateTime: hasDefaultDateTime,
                    initialDate: selectedDate!,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    initialCalendarMode: DatePickerMode.day,
                    onDateChanged: (value) {
                      selectedDate = value;
                      hasDefaultDateTime = true;
                      valueNotifier.value = valueNotifier.value + 1;
                    },
                  ),
                ),

                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/calendar.svg',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          hasDefaultDateTime
                              ? DateFormat("d MMM y").format(selectedDate!)
                              : 'No Date',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: AppColors.secondaryColor),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: AppTextStyles.defaultTextStyle.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: AppColors.primaryColor),
                          onPressed: () {
                            if (isEndDate) {
                              if (compareDate != null &&
                                  selectedDate!.day > compareDate!.day) {
                                onDateChanged(selectedDate);
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Selected Date should be greater than Start Date')));
                              }
                            } else {
                              if (compareDate == null ||
                                  (compareDate != null &&
                                      selectedDate!.day < compareDate!.day)) {
                                onDateChanged(selectedDate);
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Selected Date should be less than End Date')));
                              }
                            }
                          },
                          child: Text(
                            "Save",
                            style: AppTextStyles.defaultTextStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
