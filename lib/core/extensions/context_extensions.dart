import 'package:flutter/material.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';

extension ContextExtensions on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    if (isError) {
      AppToast.showError(message);
    } else {
      AppToast.showInformation(message);
    }
  }
}
