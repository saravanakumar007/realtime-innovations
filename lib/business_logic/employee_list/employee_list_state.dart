import 'package:employee_list/data/models/employee.dart';
import 'package:equatable/equatable.dart';

enum EmployeeStatus {
  initial,
  loading,
  loaded,
  error,
}

class EmployeeListState extends Equatable {
  const EmployeeListState(this.employees, this.employeeStatus);
  final EmployeeStatus employeeStatus;
  final List<Employee> employees;

  @override
  List<Object?> get props => [employees, employeeStatus];

  EmployeeListState copyWith(
      {List<Employee>? employees, EmployeeStatus? employeeStatus}) {
    return EmployeeListState(
        employees ?? this.employees, employeeStatus ?? this.employeeStatus);
  }
}
