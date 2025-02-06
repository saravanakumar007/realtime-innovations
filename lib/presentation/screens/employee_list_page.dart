import 'dart:convert';

import 'package:employee_list/business_logic/employee_list/employee_list_cubit.dart';
import 'package:employee_list/business_logic/employee_list/employee_list_state.dart';
import 'package:employee_list/consts/app_colors.dart';
import 'package:employee_list/consts/app_text_styles.dart';
import 'package:employee_list/data/models/employee.dart';
import 'package:employee_list/presentation/screens/add_or_edit_employee_details_page.dart';
import 'package:employee_list/presentation/widgets/employee_detail_widget.dart';
import 'package:employee_list/services/shared_prefs_service.dart';
import 'package:employee_list/utils/helpers.dart';
import 'package:employee_list/utils/undo_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    BlocProvider.of<EmployeeListCubit>(context).fetchInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeListCubit, EmployeeListState>(
      builder: (context, state) => Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: HexColor('#F2F2F2')),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 20),
                  if (state.employees.isNotEmpty)
                    Text(
                      'Swipe left to delete',
                      style: AppTextStyles.defaultTextStyle
                          .copyWith(color: HexColor('#949C9E'), fontSize: 15),
                    ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const AddOrEditEmployeeDetailsPage(),
                        ),
                      )
                          .then((value) {
                        fetchData();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primaryColor),
                      height: 40,
                      width: 40,
                      child: Center(
                        child: Text(
                          '+',
                          style: AppTextStyles.defaultTextStyle.copyWith(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40)
                ],
              ),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          centerTitle: false,
          title: Text(
            'Employee List',
            style: AppTextStyles.defaultTextStyle.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        body: state.employees.isNotEmpty
            ? _builtEmployeeRenderWidget(state.employees)
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: HexColor('#F2F2F2'),
                ),
                child: Center(
                  child: SvgPicture.asset('assets/images/no_employees.svg'),
                ),
              ),
      ),
    );
  }

  Future<void> undoData(Employee undoEmployee) async {
    final String? cacheData =
        SharedPrefsService.instance.getString('employee_data');
    List<dynamic> cacheJsonData = jsonDecode(cacheData ?? '[]');
    cacheJsonData.add(undoEmployee.toJson());
    await SharedPrefsService.instance
        .setString('employee_data', jsonEncode(cacheJsonData));
    fetchData();
  }

  Future<void> updateData(Employee deleteEmployee) async {
    final String? cacheData =
        SharedPrefsService.instance.getString('employee_data');
    List<dynamic> cacheJsonData = jsonDecode(cacheData ?? '[]');
    final List<dynamic> newJsonData = [];
    for (int i = 0; i < cacheJsonData.length; i++) {
      if (cacheJsonData[i]['id'] != deleteEmployee.id) {
        newJsonData.add(cacheJsonData[i]);
      }
    }
    await SharedPrefsService.instance
        .setString('employee_data', jsonEncode(newJsonData));
    fetchData();
  }

  Widget _builtEmployeeRenderWidget(List<Employee> employees) {
    final List<Widget> currentEmployeesRenderWidget = [];
    final List<Widget> previousEmployeesRenderWidget = [];
    employees.sort((a, b) => a.id.toString().compareTo(b.id.toString()));
    for (int i = 0; i < employees.length; i++) {
      final Employee employee = employees[i];
      if (employee.endDate != null) {
        previousEmployeesRenderWidget.add(
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => AddOrEditEmployeeDetailsPage(
                    needToEdit: true,
                    employee: employee,
                  ),
                ),
              )
                  .then((value) {
                fetchData();
              });
            },
            child: Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                updateData(employee);
                ScaffoldMessenger.of(context).showSnackBar(
                  UndoSnackbar(
                          employee: employee,
                          undoPressed: (Employee currentEmployee) {
                            undoData(currentEmployee);
                          },
                          context: context,
                          content: 'Employee data has been deleted')
                      .getSnackbarWidget(),
                );
              },
              background: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.delete,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 30)
                  ],
                ),
              ),
              child: EmployeeDetail(employee: employee),
            ),
          ),
        );
      } else {
        currentEmployeesRenderWidget.add(
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => AddOrEditEmployeeDetailsPage(
                    needToEdit: true,
                    employee: employee,
                  ),
                ),
              )
                  .then((value) {
                fetchData();
              });
            },
            child: Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                updateData(employee);
                ScaffoldMessenger.of(context).showSnackBar(
                  UndoSnackbar(
                          employee: employee,
                          undoPressed: (Employee currentEmployee) {
                            undoData(currentEmployee);
                          },
                          context: context,
                          content: 'Employee data has been deleted')
                      .getSnackbarWidget(),
                );
              },
              background: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.delete,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 30)
                  ],
                ),
              ),
              child: EmployeeDetail(employee: employee),
            ),
          ),
        );
      }
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (currentEmployeesRenderWidget.isNotEmpty) ...[
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        color: HexColor('#F2F2F2'),
                      ),
                      child: Text(
                        'Current employees',
                        style: AppTextStyles.defaultTextStyle.copyWith(
                          fontSize: 20,
                          color: HexColor('#1DA1F2'),
                        ),
                      ),
                    ),
                    ...currentEmployeesRenderWidget
                  ],
                )),
          ],
          if (previousEmployeesRenderWidget.isNotEmpty) ...[
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: HexColor('#F2F2F2'),
                  ),
                  child: Text(
                    'Previous employees',
                    style: AppTextStyles.defaultTextStyle.copyWith(
                      fontSize: 20,
                      color: HexColor('#1DA1F2'),
                    ),
                  ),
                ),
                ...previousEmployeesRenderWidget
              ],
            )
          ]
        ],
      ),
    );
  }
}
