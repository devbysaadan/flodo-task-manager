import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationViewModel extends GetxController {
  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();

  var selectedAvatar = ''.obs;

  var avatarError = ''.obs;
  var usernameError = ''.obs;

  void selectAvatar(String avatar) {
    selectedAvatar.value = avatar;
    avatarError.value = '';
  }

  bool validateForm() {
    bool isValid = true;

    if (usernameController.text
        .trim()
        .isEmpty) {
      usernameError.value = 'Username is required';
      isValid = false;
    } else {
      usernameError.value = '';
    }

    if (selectedAvatar.value.isEmpty) {
      avatarError.value = 'Please select an avatar';
      isValid = false;
    } else {
      usernameError.value = '';
    }
    if (selectedAvatar.value.isEmpty) {
      avatarError.value = 'Please select an avatar';
      isValid = false;
    } else {
      avatarError.value = '';
    }
    if (!formKey.currentState!.validate()) {
      isValid = false;
    }
    return isValid;
  }
}
