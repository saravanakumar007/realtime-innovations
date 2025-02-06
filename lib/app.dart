import 'package:employee_list/business_logic/employee_list/employee_list_cubit.dart';
import 'package:employee_list/data/repositories/employee_list_repository.dart';
import 'package:employee_list/presentation/screens/employee_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<EmployeeListCubit>(
        create: (context) => EmployeeListCubit(EmployeeListRepository()),
        child: const EmployeeListPage(),
      ),
    );
  }
}
