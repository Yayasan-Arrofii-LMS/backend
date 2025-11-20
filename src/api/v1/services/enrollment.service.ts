import { EnrollmentRepository } from '../repositories/enrollment.repository';
import { EnrollClassInput, UnenrollClassInput } from '../types/enrollment.type';

export class EnrollmentService {
    // Enroll user to a class
    static async enrollClass(userId: string, data: EnrollClassInput) {
        // Check if class exists
        const classData = await EnrollmentRepository.getClassById(data.classId);
        if (!classData) {
            throw new Error('Class not found');
        }

        // Check if user is already enrolled
        const isEnrolled = await EnrollmentRepository.isUserEnrolled(userId, data.classId);
        if (isEnrolled) {
            throw new Error('You are already enrolled in this class');
        }

        // Enroll user
        return await EnrollmentRepository.enrollUser(userId, data.classId);
    }

    // Unenroll user from a class
    static async unenrollClass(userId: string, data: UnenrollClassInput) {
        // Check if class exists
        const classData = await EnrollmentRepository.getClassById(data.classId);
        if (!classData) {
            throw new Error('Class not found');
        }

        // Check if user is enrolled
        const isEnrolled = await EnrollmentRepository.isUserEnrolled(userId, data.classId);
        if (!isEnrolled) {
            throw new Error('You are not enrolled in this class');
        }

        // Unenroll user
        return await EnrollmentRepository.unenrollUser(userId, data.classId);
    }

    // Get user's enrolled classes
    static async getMyEnrolledClasses(userId: string) {
        return await EnrollmentRepository.getUserEnrolledClasses(userId);
    }

    // Check enrollment status
    static async checkEnrollment(userId: string, classId: number) {
        const enrollment = await EnrollmentRepository.getUserEnrollment(userId, classId);
        return {
            isEnrolled: !!enrollment,
            enrollment: enrollment || null,
        };
    }
}
