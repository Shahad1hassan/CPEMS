
import 'package:flutter/foundation.dart';

class PatientStore {
  static final ValueNotifier<String> name = ValueNotifier('');

  static final ValueNotifier<DateTime?> dateOfBirth =
      ValueNotifier(null);

  static final ValueNotifier<String?> sex =
      ValueNotifier(null);

  static final ValueNotifier<String> phoneNumber =
      ValueNotifier('');

  static void setName(String value) {
    name.value = value.trim();
  }

  static void updateProfile({
    required String name,
    DateTime? dateOfBirth,
    String? sex,
    required String phoneNumber,
  }) {
    PatientStore.name.value = name.trim();
    PatientStore.dateOfBirth.value = dateOfBirth;
    PatientStore.sex.value = sex;
    PatientStore.phoneNumber.value = phoneNumber.trim();
  }
}
