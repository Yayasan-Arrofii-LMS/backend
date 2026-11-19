import { Router } from 'express';
import { EnrollmentController } from '../controllers/enrollment.controller';
import { authMiddleware } from '../middlewares/auth.middleware';
import { verifyRole } from '../middlewares/verifyrole.middleware';
import { validateBody } from '../middlewares/schema.middleware';
import {
    enrollClassSchema,
    unenrollClassSchema,
    updateApplicantStatusSchema,
} from '../schemas/enrollment.schema';

const router = Router();

// === STUDENT ENROLLMENT ===

// Enroll to a class
router.post(
    '/enroll',
    authMiddleware,
    verifyRole(['Student', 'Teacher']),
    validateBody(enrollClassSchema),
    EnrollmentController.enrollClass
);

// Unenroll from a class
router.post(
    '/unenroll',
    authMiddleware,
    verifyRole(['Student', 'Teacher']),
    validateBody(unenrollClassSchema),
    EnrollmentController.unenrollClass
);

// Get my enrolled classes
router.get(
    '/my-classes',
    authMiddleware,
    verifyRole(['Student', 'Teacher']),
    EnrollmentController.getMyEnrolledClasses
);

// Check enrollment status
router.get(
    '/check/:classId',
    authMiddleware,
    verifyRole(['Student', 'Teacher']),
    EnrollmentController.checkEnrollment
);

// === TEACHER / ADMIN APPROVAL ===

// Get list of applicants for a class
router.get(
    '/class/:classId/applicants',
    authMiddleware,
    verifyRole(['Teacher', 'Admin']),
    EnrollmentController.getClassApplicants
);

// Approve or reject an applicant
router.patch(
    '/applicants/:userClassId/status',
    authMiddleware,
    verifyRole(['Teacher', 'Admin']),
    validateBody(updateApplicantStatusSchema),
    EnrollmentController.updateApplicantStatus
);

export default router;
