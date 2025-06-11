class MedicalHistoryModel {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String diagnosis;
  final String treatment;
  final String? notes;
  final DateTime lastUpdated;

  MedicalHistoryModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.diagnosis,
    required this.treatment,
    this.notes,
    required this.lastUpdated,
  });

  factory MedicalHistoryModel.fromJson(Map<String, dynamic> json) {
    // Handle patientId and patientName
    String extractedPatientId = '';
    String extractedPatientName = 'Unknown Patient';
    if (json['patientId'] != null) {
      if (json['patientId'] is Map) {
        extractedPatientId = json['patientId']['_id']?.toString() ?? '';
        extractedPatientName = json['patientId']['name']?.toString() ?? 'Unknown Patient';
      } else {
        extractedPatientId = json['patientId'].toString();
        extractedPatientName = json['patientName']?.toString() ?? 'Unknown Patient';
      }
    }

    // Handle doctorId and doctorName
    String extractedDoctorId = '';
    String extractedDoctorName = 'Unknown Doctor';
    if (json['doctorId'] != null) {
      if (json['doctorId'] is Map) {
        extractedDoctorId = json['doctorId']['_id']?.toString() ?? '';
        extractedDoctorName = json['doctorId']['name']?.toString() ?? 'Unknown Doctor';
      } else {
        extractedDoctorId = json['doctorId'].toString();
        extractedDoctorName = json['doctorName']?.toString() ?? 'Unknown Doctor';
      }
    }

    return MedicalHistoryModel(
      id: json['_id']?.toString() ?? '',
      patientId: extractedPatientId,
      patientName: extractedPatientName,
      doctorId: extractedDoctorId,
      doctorName: extractedDoctorName,
      diagnosis: json['diagnosis']?.toString() ?? 'No diagnosis provided',
      treatment: json['treatment']?.toString() ?? 'No treatment provided',
      notes: json['notes']?.toString(),
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.tryParse(json['lastUpdated'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'notes': notes,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}