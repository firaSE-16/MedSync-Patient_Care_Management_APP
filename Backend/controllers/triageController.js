const MedicalHistory = require('../models/medicalHistoryModel');

const Appointment = require('../models/appointmentModel');
const Booking = require('../models/bookingModel');
const User = require('../models/userModel');
const asyncHandler = require('express-async-handler');

exports.getUnassignedBookings = asyncHandler(async (req, res) => {
  const { page = 1, limit = 10 } = req.query;
  const startIndex = (page - 1) * limit;
  const endIndex = 100
  

  const total = await Booking.countDocuments({ status: 'pending' });
  const bookings = await Booking.find({ status: 'pending' })
    .populate('patientId', 'name email dateOfBirth gender bloodGroup')
    .sort({ createdAt: 1 })
    .skip(startIndex)
    .limit(limit);
 

  const pagination = {};
  if (endIndex <= total) {
    pagination.next = {
      page: parseInt(page) + 1,
      limit: parseInt(limit)
    };
  }

  if (startIndex > 0) {
    pagination.prev = {
      page: parseInt(page) - 1,
      limit: parseInt(limit)
    };
  }
  console.log(bookings);

  res.status(200).json({
    success: true,
    count: bookings.length,
    pagination,
    data: bookings
  });
});

exports.getAvailableDoctors = asyncHandler(async (req, res) => {
  const { department } = req.query;
  
  const query = { role: 'doctor' };
  if (department) query.department = department;

  const doctors = await User.find(query)
    .select('name specialization department');

  res.status(200).json({
    success: true,
    count: doctors.length,
    data: doctors
  });
});

exports.processTriage = asyncHandler(async (req, res) => {
  const { bookingId } = req.params;
  const { doctorId, vitals, priority, notes } = req.body;
  const triageId = req.user.id;

  const booking = await Booking.findById(bookingId);
  if (!booking || booking.status !== 'pending') {
    return res.status(400).json({
      success: false,
      message: 'Invalid or already processed booking'
    });
  }

  const doctor = await User.findOne({ _id: doctorId, role: 'doctor' });
  if (!doctor) {
    return res.status(400).json({
      success: false,
      message: 'Invalid doctor selection'
    });
  }

  const medicalHistory = await MedicalHistory.findOneAndUpdate(
    { patientId: booking.patientId },
    {
      $set: {
        doctorId,
        triageData: {
          vitals,
          triageId,
          triageDate: new Date(),
          priority,
          notes
        }
      }
    },
    { new: true, upsert: true }
  );

  const appointment = new Appointment({
    bookingId: booking._id,
    patientId: booking.patientId,
    doctorId,
    date: booking.preferredDate || new Date(),
    time: booking.preferredTime || '09:00',
    status: 'scheduled',
    reason: booking.symptoms,
    priority,
    triageNotes: notes
  });

  await appointment.save();

  booking.status = 'assigned';
  await booking.save();

  res.status(201).json({
    success: true,
    data: {
      appointment,
      medicalHistory
    }
  });
});

exports.updateMedicalHistory = asyncHandler(async (req, res) => {
  const { patientId } = req.params;
  const { allergies, chronicConditions, surgeries, familyHistory, immunizations } = req.body;

  const updateData = {
    lastUpdated: new Date()
  };

  if (allergies) updateData.allergies = allergies;
  if (chronicConditions) updateData.chronicConditions = chronicConditions;
  if (surgeries) updateData.surgeries = surgeries;
  if (familyHistory) updateData.familyHistory = familyHistory;
  if (immunizations) updateData.immunizations = immunizations;

  const medicalHistory = await MedicalHistory.findOneAndUpdate(
    { patientId },
    updateData,
    { new: true }
  );

  if (!medicalHistory) {
    return res.status(404).json({
      success: false,
      message: 'Medical history not found - process triage first'
    });
  }

  res.status(200).json({
    success: true,
    data: medicalHistory
  });
});




exports.getPatients = asyncHandler(async (req, res) => {
  const { department } = req.query;
  
  const query = { role: 'patient' };
  if (department) query.department = department;

  const patients = await User.find(query)
    .select('name gender age bloodGroup department medicalHistory')
    .sort({ name: 1 });

  res.status(200).json({
    success: true,
    count: patients.length,
    data: patients
  });
});
