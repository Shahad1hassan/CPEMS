
import 'package:flutter/foundation.dart';

class MedicalInformationStore {
  static final ValueNotifier<String?> asthmaDiagnosis =
      ValueNotifier(null);

  static final ValueNotifier<DateTime?> diagnosisDate =
      ValueNotifier(null);

  static final ValueNotifier<List<String>> asthmaTriggers =
      ValueNotifier([]);

  static final ValueNotifier<String> emergencyContactName =
      ValueNotifier('');

  static final ValueNotifier<String> emergencyContactPhone =
      ValueNotifier('');

  static void update({
    String? asthmaDiagnosis,
    DateTime? diagnosisDate,
    required List<String> asthmaTriggers,
    required String emergencyContactName,
    required String emergencyContactPhone,
  }) {
    MedicalInformationStore.asthmaDiagnosis.value = asthmaDiagnosis;
    MedicalInformationStore.diagnosisDate.value = diagnosisDate;
    MedicalInformationStore.asthmaTriggers.value =
        List<String>.from(asthmaTriggers);
    MedicalInformationStore.emergencyContactName.value =
        emergencyContactName.trim();
    MedicalInformationStore.emergencyContactPhone.value =
        emergencyContactPhone.trim();
  }
}
