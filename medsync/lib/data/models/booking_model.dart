class BookingModel {
  final String id;
  final String patientId;
  final String patientName;
  final String lookingFor;
  final String priority;
  final String preferredDate;
  final String preferredTime;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.lookingFor,
    required this.priority,
    required this.preferredDate,
    required this.preferredTime,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // Handle patientId as string or map
    String patientId;
    String patientName;
    if (json['patientId'] is Map) {
      patientId = json['patientId']['_id'] ?? '';
      patientName = json['patientId']['name'] ?? '';
    } else {
      patientId = json['patientId'] ?? '';
      patientName = json['patientName'] ?? '';
    }

    return BookingModel(
      id: json['_id'] as String,
      patientId: patientId,
      patientName: patientName,
      lookingFor: json['lookingFor'] as String,
      priority: json['priority'] as String,
      preferredDate: json['preferredDate'] as String,
      preferredTime: json['preferredTime'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'patientName': patientName,
      'lookingFor': lookingFor,
      'priority': priority,
      'preferredDate': preferredDate,
      'preferredTime': preferredTime,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}