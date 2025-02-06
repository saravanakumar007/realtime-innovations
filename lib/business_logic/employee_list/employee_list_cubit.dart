import 'dart:convert';

import 'package:employee_list/business_logic/employee_list/employee_list_state.dart';
import 'package:employee_list/data/models/employee.dart';
import 'package:employee_list/data/repositories/employee_list_repository.dart';
import 'package:employee_list/services/shared_prefs_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeListCubit extends Cubit<EmployeeListState> {
  final EmployeeListRepository employeeListRepository;
  EmployeeListCubit(this.employeeListRepository)
      : super(const EmployeeListState([], EmployeeStatus.initial));

  Future<void> fetchInitialData() async {
    emit(state.copyWith(employeeStatus: EmployeeStatus.loading));
    String? cacheData = SharedPrefsService.instance.getString('employee_data');
    List<dynamic> jsonData = jsonDecode(cacheData ?? '[]');
    List<Employee> employees =
        jsonData.map((json) => Employee.fromJson(json)).toList();
    emit(state.copyWith(
        employees: employees, employeeStatus: EmployeeStatus.loaded));
  }

  void updateData(int index) {
    state.employees.removeAt(index);
    state.copyWith(employeeStatus: EmployeeStatus.loaded);
  }
}
