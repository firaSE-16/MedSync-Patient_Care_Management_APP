const express = require('express');
const router = express.Router();
const patientController = require('../controllers/patientController');
const { authenticate, authorize } = require('../middlewares/authMiddlewares');

// Doctors
router.get(
  '/doctors',
  authenticate,
  authorize('patient'),
  patientController.getPatientDoctors
);

// Medical History
router.get(
  '/medical-history',
  authenticate,
  authorize('patient'),
  patientController.getPatientMedicalHistory
);

// Prescriptions
router.get(
  '/prescriptions',
  authenticate,
  authorize('patient'),
  patientController.getPatientPrescriptions
);

// Bookings
router.get(
  '/bookings',
  authenticate,
  authorize('patient'),
  patientController.getPatientBookings
);

router.post(
  '/bookings',
  authenticate,
  authorize('patient'),
  patientController.createBooking
);

router.put(
  '/bookings/:id/cancel',
  authenticate,
  authorize('patient'),
  patientController.cancelBooking
);

// Appointments
router.get(
  '/appointments',
  authenticate,
  authorize('patient'),
  patientController.getPatientAppointments
);


router.get(
  '/medical-records',
  authenticate,
  authorize('patient'),
  patientController.getPatientMedicalRecords
);

// Dashboard
router.get(
  '/dashboard',
  authenticate,
  authorize('patient'),
  patientController.getPatientDashboard
);

// GET all prescriptions for a patient
router.get('/patients',authenticate,
  authorize('patient'), patientController.getPatientPrescriptions);

module.exports = router;
