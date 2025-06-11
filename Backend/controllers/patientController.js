const Prescription = require('../models/prescriptionModel');
const MedicalHistory = require('../models/medicalHistoryModel');

const Appointment = require('../models/appointmentModel');
const Booking = require('../models/bookingModel');
const User = require('../models/userModel');
const asyncHandler = require('express-async-handler');

exports.getPatientDoctors = asyncHandler(async (req, res) => {
  const patientId = req.user.id;

  const [medicalDoctors, appointmentDoctors] = await Promise.all([
    MedicalHistory.find({ patientId }).distinct('doctorId'),
    Appointment.find({ patientId }).distinct('doctorId')
  ]);

  const uniqueDoctorIds = [...new Set([...medicalDoctors, ...appointmentDoctors])];

  const doctors = await User.find({ 
    _id: { $in: uniqueDoctorIds },
    role: 'doctor'
  }).select('name specialization department profilePicture');

  res.status(200).json({
    success: true,
    count: doctors.length,
    data: doctors
  });
});

exports.getPatientMedicalHistory = asyncHandler(async (req, res) => {
  const patientId = req.user.id;
  
  // Use find() instead of findOne() to get all medical history records
  const medicalHistory = await MedicalHistory.find({ patientId })
    .populate('doctorId', 'name') // Only populate the name field
    .sort({ lastUpdated: -1 }); // Sort by most recent first

  if (!medicalHistory || medicalHistory.length === 0) {
    return res.status(200).json({
      success: true,
      data: [], // Return empty array to match frontend expectation
      message: 'No medical history found'
    });
  }

  // Transform the data to match frontend expectations
  const formattedHistory = medicalHistory.map(record => ({
    id: record._id,
    patientId: record.patientId,
    patientName: record.patientName,
    doctorId: record.doctorId._id,
    doctorName: record.doctorId.name,
    diagnosis: record.diagnosis,
    treatment: record.treatment,
    notes: record.notes,
    lastUpdated: record.lastUpdated
  }));
  

  res.status(200).json({
    success: true,
    data: formattedHistory // Send as array
  });
});

exports.getPatientBookings = asyncHandler(async (req, res) => {
  const patientId = req.user.id;
  const { status } = req.query;

  const query = { patientId };
  if (status) query.status = status;

  const bookings = await Booking.find(query)
    .sort({ createdAt: -1 });

  res.status(200).json({
    success: true,
    count: bookings.length,
    data: bookings
  });
});

exports.createBooking = asyncHandler(async (req, res) => {
  const patientId = req.user.id;
  const { priority, preferredDate, preferredTime, lookingFor, notes, patientName } = req.body;

  if (!lookingFor) {
    return res.status(400).json({
      success: false,
      message: 'Please specify which type of doctor you are looking for'
    });
  }

  const allowedSpecialties = [
    'dermatologist',
    'pathologist',
    'cardiologist',
    'neurologist',
    'pediatrician',
    'psychiatrist',
    'general physician',
    'dentist',
  ];

  if (!allowedSpecialties.includes(lookingFor.toLowerCase())) {
    return res.status(400).json({
      success: false,
      message: 'Invalid specialty. Please choose from the allowed specialties',
      allowedSpecialties
    });
  }

  if (!preferredDate || !preferredTime) {
    return res.status(400).json({
      success: false,
      message: 'Preferred date and time are required'
    });
  }

  const bookingDateTime = new Date(`${preferredDate}T${preferredTime}`);
  if (isNaN(bookingDateTime.getTime())) 
    return res.status(400).json({
      success: false,
      message: 'Invalid date/time format'
    });
  

  if (bookingDateTime < new Date()) {
    return res.status(400).json({
      success: false,
      message: 'Booking date/time cannot be in the past'
    });
  }

  let finalPatientName = patientName;
  if (!finalPatientName) {
    const patient = await User.findById(patientId).select('name');
    if (!patient) {
      return res.status(404).json({
        success: false,
        message: 'Patient not found'
      });
    }
    finalPatientName = patient.name;
  }

  const booking = new Booking({
    patientId,
    patientName: finalPatientName,
    lookingFor: lookingFor.toLowerCase(),
    priority: priority || 'medium',
    preferredDate,
    preferredTime,
    notes: notes || '',
    status: 'pending'
  });

  await booking.save();
  await booking.populate('patientId', 'name email');

  res.status(201).json({
    success: true,
    data: booking
  });
});



exports.cancelBooking = asyncHandler(async (req, res) => {
  const bookingId = req.params.id;
  const patientId = req.user.id;

  const booking = await Booking.findOneAndDelete(
    { _id: bookingId, patientId, status: 'pending' }
  );

  if (!booking) {
    return res.status(404).json({
      success: false,
      message: 'Booking not found or already processed'
    });
  }

  res.status(200).json({
    success: true,
    data: booking
  });
});

exports.getPatientAppointments = asyncHandler(async (req, res) => {
  const patientId = req.user.id;
  const { status, upcoming } = req.query;

  const query = { patientId };
  if (status) query.status = 'pending';
  
  if (upcoming === 'true') {
    
    query.status = 'pending';
  }

  const appointments = await Appointment.find({status : ['pending', 'scheduled', 'completed']})
    .populate('doctorId', 'name specialization department profilePicture')
    .sort({ date: 1, time: 1 });

  res.status(200).json({
    success: true,
    count: appointments.length,
    data: appointments
  });
});

exports.getPatientDashboard = asyncHandler(async (req, res) => {
  const patientId = req.user.id;

  const [
    upcomingAppointments,
    recentPrescriptions,
    pendingBookings,
    medicalHistory
  ] = await Promise.all([
    Appointment.find({ 
      patientId, 
      status: 'scheduled',
      date: { $gte: new Date() }
    })
    .sort({ date: 1 })
    .limit(3)
    .populate('doctorId', 'name specialization'),
    
    Prescription.find({ patientId })
      .sort({ date: -1 })
      .limit(3)
      .populate('doctorId', 'name'),

    Booking.find({ patientId, status: 'pending' })
      .sort({ createdAt: -1 })
      .limit(3),
      
    MedicalHistory.findOne({ patientId })
      .select('allergies chronicConditions')
  ]);
  

  res.status(200).json({
    success: true,
    data: {
      upcomingAppointments,
      recentPrescriptions,
      pendingBookings,
      allergies: medicalHistory?.allergies || [],
      conditions: medicalHistory?.chronicConditions || []
    }
  });
});


exports.getPatientMedicalRecords = asyncHandler(async (req, res) => {
  const patientId = req.user.id
  const hasAppointments = await Appointment.exists({
    patientId,
    doctorId,
    status: { $in: ['scheduled', 'completed'] }
  });

  if (!hasAppointments) {
    return res.status(403).json({
      success: false,
      message: 'Not authorized to access this patient\'s records'
    });
  }

  const medicalRecords = await MedicalHistory.find({ patientId, doctorId })
    .populate('doctorId', 'name specialization')
    .populate('patientId', 'name dateOfBirth gender');

  if (!medicalRecords || medicalRecords.length === 0) {
    return res.status(404).json({
      success: false,
      message: 'No medical records found for this patient'
    });
  }

  res.status(200).json({
    success: true,
    data: medicalRecords
  });
});

exports.getPatientPrescriptions = asyncHandler(async (req, res) => {

  const patientId = req.user.id;

  

  const prescriptions = await Prescription.find({ patientId })
    

  if (!prescriptions.length) {
    return res.status(404).json({
      success: false,
      message: 'No prescriptions found for this patient'
    });
  }

  res.status(200).json({
    success: true,
    data: prescriptions
  });
});

