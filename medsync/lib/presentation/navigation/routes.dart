class AppRoutes {
  static const String splash = '/splash';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';

  // Doctor Routes
  static const String doctorHome = '/doctor/home';
  static const String doctorChat = '/doctor/chat';
  static const String doctorAppointment = '/doctor/appointments';
  static const String doctorProfile = '/doctor/profile';
  static const String patientDetail = '/doctor/patient-detail/:id';
  static const String doctorPrescription = '/doctor/patient-prescription';
  static const String doctorHistory = '/doctor/patient-history';
  static const String doctorCreateMedicalRecord = '/doctor/create-medical-record';
  static const String doctorEditMedicalRecord = '/doctor/edit-medical-record/:id';
  static const String doctorCreatePrescription = '/doctor/create-prescription';
  static const String doctorEditPrescription = '/doctor/edit-prescription/:id';
  static const String doctorPatients = '/doctor/patients';

  // Patient Routes
static const String patientHome = '/patient/home';
  static const String patientAppointment = '/patient/appointments';
  static const String patientChat = '/patient/chat';
  static const String patientProfile = '/patient/profile';
  static const String patientDoctors = '/patient/doctors';
  static const String patientChatScreen = '/patient/chat/:id';
  static const String patientPrescription = '/patient/prescriptions';
  static const String patientMedicalHistory = '/patient/medical-history';
  static const String patientBooking = '/patient/bookings';
  // Triage Routes
  static const String triageHome = '/triage/home';
  static const String triagePatientDetail = '/triage/patient-detail/:id';
  static const String triageBookingDetail = '/triage/booking/:id';

  // Admin Routes
  static const String adminHome = '/admin/home';
  static const String adminStaff = '/admin/staff';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminStaffDetail = '/admin/staff/:id';
  static const String adminPatientAppointments = '/admin/patient-appointments';
}