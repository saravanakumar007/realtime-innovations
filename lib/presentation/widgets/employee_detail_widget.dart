import 'package:employee_list/consts/app_text_styles.dart';
import 'package:employee_list/data/models/employee.dart';
import 'package:employee_list/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeDetail extends StatelessWidget {
  const EmployeeDetail({super.key, required this.employee});

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employee.name,
            style: AppTextStyles.defaultTextStyle
                .copyWith(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Text(
            employee.role,
            style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 20,
                color: HexColor('#949C9E'),
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            employee.endDate == null
                ? 'From ${DateFormat("d MMM, y").format(employee.startDate)}'
                : '${DateFormat("d MMM, y").format(employee.startDate)} -  ${DateFormat("d MMM, y").format(employee.endDate!)}',
            style: AppTextStyles.defaultTextStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: HexColor('#949C9E')),
          )
        ],
      ),
    );
  }
}
