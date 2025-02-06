import 'package:employee_list/consts/app_colors.dart';
import 'package:employee_list/consts/app_text_styles.dart';
import 'package:employee_list/data/models/employee.dart';
import 'package:flutter/material.dart';

class UndoSnackbar {
  const UndoSnackbar({
    required this.context,
    required this.content,
    required this.employee,
    this.undoPressed,
  });

  final BuildContext context;

  final String content;

  final Employee employee;

  final Function? undoPressed;

  SnackBar getSnackbarWidget() {
    return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(milliseconds: 2000),
      content: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
            ),
            color: Colors.black,
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: const Offset(0, 8),
                spreadRadius: 0,
                blurRadius: 20,
                color: Colors.black.withOpacity(0.2),
              )
            ]),
        child: Row(
          children: [
            Expanded(
              child: Text(
                content,
                style: AppTextStyles.defaultTextStyle
                    .copyWith(color: Colors.white),
              ),
            ),
            InkWell(
              onTap: () {
                if (undoPressed != null) {
                  undoPressed!(employee);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 5),
                  Text(
                    'Undo',
                    style: AppTextStyles.defaultTextStyle
                        .copyWith(color: AppColors.primaryColor),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
