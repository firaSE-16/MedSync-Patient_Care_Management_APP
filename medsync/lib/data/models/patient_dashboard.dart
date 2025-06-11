class PatientDashboardData {
  final int totalAppointments;
  final int upcomingAppointments;
  final int completedAppointments;
  final int cancelledAppointments;

  PatientDashboardData({
    required this.totalAppointments,
    required this.upcomingAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
  });

  factory PatientDashboardData.fromJson(Map<String, dynamic> json) {
    return PatientDashboardData(
      totalAppointments: json['appointments'] ?? 0,
      upcomingAppointments: json['upcomingAppointments'] ?? 0,
      completedAppointments: json['completedAppointments'] ?? 0,
      cancelledAppointments: json['cancelledAppointments'] ?? 0,
    );
  }
}