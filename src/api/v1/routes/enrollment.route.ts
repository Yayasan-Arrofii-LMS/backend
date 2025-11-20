import { Router } from 'express';
import { EnrollmentController } from '../controllers/enrollment.controller';
import { authMiddleware } from '../middlewares/auth.middleware';
import { verifyRole } from '../middlewares/verifyrole.middleware';
import { validateBody } from '../middlewares/schema.middleware';
import { enrollClassSchema, unenrollClassSchema } from '../schemas/enrollment.schema';

const router = Router();

// === STUDENT ENROLLMENT ===

// Enroll to a class
router.post(
    '/enroll',
    authMiddleware,
    verifyRole(['Student']),
    validateBody(enrollClassSchema),
    EnrollmentController.enrollClass
);

// Unenroll from a class
router.post(
    '/unenroll',
    authMiddleware,
    verifyRole(['Student']),
    validateBody(unenrollClassSchema),
    EnrollmentController.unenrollClass
);

// Get my enrolled classes
router.get(
    '/my-classes',
    authMiddleware,
    verifyRole(['Student']),
    EnrollmentController.getMyEnrolledClasses
);

// Check enrollment status
router.get(
    '/check/:classId',
    authMiddleware,
    verifyRole(['Student']),
    EnrollmentController.checkEnrollment
);

export default router;
