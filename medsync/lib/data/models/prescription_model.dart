class Medication {
  final String? name;
  final String? dosage;
  final String? frequency;
  final String? description;
  final num? price;

  Medication({
    this.name,
    this.dosage,
    this.frequency,
    this.description,
    this.price,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      name: json['name'] as String?,
      dosage: json['dosage'] as String?,
      frequency: json['frequency'] as String?,
      description: json['description'] as String?,
      price: json['price'] as num?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'description': description,
      'price': price,
    };
  }
}

class PrescriptionModel {
  final String id;
  final String patientId;
  final String doctorId;
  final String? doctorName; // Populated from doctorId
  final List<Medication> medications;
  final DateTime createdAt; // Assuming you'll add this to your schema and API

  PrescriptionModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    this.doctorName,
    required this.medications,
    required this.createdAt,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    String? doctorName;
    if (json['doctorId'] is Map) {
      doctorName = json['doctorId']['name'] as String?;
    }

    return PrescriptionModel(
      id: json['_id'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] is Map ? json['doctorId']['_id'] : json['doctorId'] as String,
      doctorName: doctorName,
      medications: (json['medications'] as List<dynamic>?)
              ?.map((e) => Medication.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()), // Assume createdAt is added to backend schema
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'medications': medications.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}