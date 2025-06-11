const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminContoller');
const { authenticate, authorize } = require('../middlewares/authMiddlewares');



router.post('/register', adminController.registerAdmin);


router.post(
  '/staff',
  authenticate,
  authorize('admin'),
  adminController.registerStaff
);


router.get(
  '/staff/:role',
  authenticate,
  authorize('admin'),
  adminController.getStaffByCategory
);


router.get(
  '/dashboard-stats',
  authenticate,
  authorize('admin'),
  adminController.getDashboardStats
);


router.get(
  '/appointments',
  authenticate,
  authorize('admin'),
  adminController.getAppointmentsByStatus
);


router.get(
  '/patients',
  authenticate,
  authorize('admin'),
  adminController.getPatients
);

module.exports = router;
