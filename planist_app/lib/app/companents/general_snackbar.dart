import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showGeneralSnackbar({
  required String title,
  required String message,
  Color? backgroundColor,
  Color? colorText,
}) {
  Get.snackbar(
    title,
    message,
    backgroundColor: backgroundColor,
    colorText: colorText ?? Colors.white,
    margin: const EdgeInsets.all(16),
  );
}
