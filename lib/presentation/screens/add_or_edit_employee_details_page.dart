import 'dart:convert';

import 'package:employee_list/consts/app_colors.dart';
import 'package:employee_list/consts/app_text_styles.dart';
import 'package:employee_list/data/models/employee.dart';
import 'package:employee_list/presentation/widgets/dialog_date_picker.dart';
import 'package:employee_list/services/shared_prefs_service.dart';
import 'package:employee_list/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class AddOrEditEmployeeDetailsPage extends StatefulWidget {
  const AddOrEditEmployeeDetailsPage({
    super.key,
    this.needToEdit = false,
    this.employee,
  });

  final bool needToEdit;

  final Employee? employee;

  @override
  State createState() => _AddOrEditEmployeeDetailsPageState();
}

class _AddOrEditEmployeeDetailsPageState
    extends State<AddOrEditEmployeeDetailsPage> {
  TextEditingController employeeNameController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  String? employeeRole;
  bool isFirstTimeClicked = false;

  @override
  void initState() {
    super.initState();
    startDate =
        widget.employee != null ? widget.employee!.startDate : DateTime.now();
    if (widget.needToEdit) {
      endDate = widget.employee!.endDate;
      employeeNameController =
          TextEditingController(text: widget.employee!.name);
      employeeRole = widget.employee!.role;
    }
  }

  void showRoleBottomSheet() {
    final List<String> roleNames = [
      'Product Designer',
      'Flutter Developer',
      'QA Tester',
      'Product Owner'
    ];
    showModalBottomSheet(
      elevation: 0,
      shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(16)),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(
              4,
              (int index) => GestureDetector(
                onTap: () {
                  setState(() {
                    employeeRole = roleNames[index];
                    Navigator.pop(context);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: HexColor('#E5E5E5'),
                      ),
                    ),
                  ),
                  child: Text(
                    roleNames[index],
                    textAlign: TextAlign.center,
                    style: AppTextStyles.defaultTextStyle,
                  ),
                ),
              ),
            ).toList()
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTodayDate = startDate!.day == DateTime.now().day &&
        startDate!.month == DateTime.now().month &&
        startDate!.year == DateTime.now().year;
    final OutlineInputBorder outlinedBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: HexColor('#E5E5E5'),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        backgroundColor: AppColors.primaryColor,
        centerTitle: false,
        title: Text(
          '${widget.needToEdit ? 'Edit' : 'Add'} Employee Details',
          style: AppTextStyles.defaultTextStyle.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              child: TextField(
                controller: employeeNameController,
                onChanged: (value) {
                  if (isFirstTimeClicked) {
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person_outlined,
                    color: AppColors.primaryColor,
                  ),
                  hintText: 'Employee name',
                  hintStyle: AppTextStyles.defaultTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    color: HexColor('#949C9E'),
                  ),
                  border: outlinedBorder,
                  focusedBorder: outlinedBorder,
                  enabledBorder: outlinedBorder,
                  disabledBorder: outlinedBorder,
                ),
              ),
            ),
            const SizedBox(height: 4),
            if (isFirstTimeClicked &&
                employeeNameController.text.trim().isEmpty)
              Text(
                'Please Provide the Employee name',
                style:
                    AppTextStyles.defaultTextStyle.copyWith(color: Colors.red),
              ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                showRoleBottomSheet();
              },
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: HexColor('#E5E5E5'),
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/role.svg',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        employeeRole ?? 'Select Role',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.defaultTextStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          color: employeeRole == null
                              ? HexColor('#949C9E')
                              : HexColor('#323238'),
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/images/arrow_down.svg',
                      height: 10,
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
            if (isFirstTimeClicked && employeeRole == null) ...[
              const SizedBox(height: 4),
              Text(
                'Please select any Role',
                style:
                    AppTextStyles.defaultTextStyle.copyWith(color: Colors.red),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      DialogDatePicker(
                        compareDate: endDate,
                        buildContext: context,
                        onDateChanged: (DateTime? datetime) {
                          if (datetime != null) {
                            setState(() {
                              startDate = datetime;
                            });
                          }
                        },
                        initiaDate: DateTime.now(),
                      ).showDialogDatePicker();
                    },
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: HexColor('#E5E5E5'),
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/calendar.svg',
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isTodayDate
                                ? 'Today'
                                : DateFormat("d MMM y").format(startDate!),
                            style: AppTextStyles.defaultTextStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              color: HexColor('#323238'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Icon(
                  Icons.arrow_forward,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      DialogDatePicker(
                          compareDate: startDate,
                          isEndDate: true,
                          buildContext: context,
                          initiaDate: endDate,
                          onDateChanged: (DateTime? datetime) {
                            if (datetime != null) {
                              setState(() {
                                endDate = datetime;
                              });
                            }
                          }).showDialogDatePicker();
                    },
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: HexColor('#E5E5E5'),
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/calendar.svg',
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            endDate != null
                                ? DateFormat("d MMM y").format(endDate!)
                                : 'No Date',
                            style: AppTextStyles.defaultTextStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              color: endDate == null
                                  ? HexColor('#949C9E')
                                  : HexColor('#323238'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.defaultTextStyle.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: AppColors.primaryColor),
                  onPressed: () async {
                    setState(() {
                      isFirstTimeClicked = true;
                    });
                    if (employeeNameController.text.trim().isNotEmpty &&
                        employeeRole != null) {
                      final String? cacheData = SharedPrefsService.instance
                          .getString('employee_data');
                      List<dynamic> cacheJsonData =
                          jsonDecode(cacheData ?? '[]');

                      if (widget.needToEdit) {
                        for (int i = 0; i < cacheJsonData.length; i++) {
                          if (cacheJsonData[i]['id'] == widget.employee!.id) {
                            cacheJsonData[i] = {
                              'id': cacheJsonData.length,
                              'name': employeeNameController.text,
                              'role': employeeRole,
                              'startDate': startDate!.millisecondsSinceEpoch,
                              'endDate': endDate != null
                                  ? endDate!.millisecondsSinceEpoch
                                  : null
                            };
                          }
                        }
                      } else {
                        final dynamic currentJsonData = {
                          'id': DateTime.now().millisecondsSinceEpoch,
                          'name': employeeNameController.text,
                          'role': employeeRole,
                          'startDate': startDate!.millisecondsSinceEpoch,
                          'endDate': endDate != null
                              ? endDate!.millisecondsSinceEpoch
                              : null
                        };
                        cacheJsonData.add(currentJsonData);
                      }
                      SharedPrefsService.instance.setString(
                          'employee_data', jsonEncode(cacheJsonData));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'Save',
                    style: AppTextStyles.defaultTextStyle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewPadding.bottom)
              ],
            )
          ],
        ),
      ),
    );
  }
}
