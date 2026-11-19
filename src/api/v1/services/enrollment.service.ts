import { class_approval_status, class_role, EnrollmentStatus, RegistrationType } from '@prisma/client';
import { EnrollmentRepository } from '../repositories/enrollment.repository';
import {
    EnrollClassInput,
    UnenrollClassInput,
    UpdateApplicantStatusInput,
} from '../types/enrollment.type';

export class EnrollmentError extends Error {
    statusCode: number;
    constructor(message: string, statusCode: number = 400) {
        super(message);
        this.name = 'EnrollmentError';
        this.statusCode = statusCode;
    }
}

export class EnrollmentService {
    // Enroll user to a class
    static async enrollClass(userId: string, data: EnrollClassInput) {
        // Check if class exists
        const classData = await EnrollmentRepository.getClassById(data.classId);
        if (!classData) {
            throw new EnrollmentError('Class not found', 404);
        }

        // Prevent teacher from enrolling in their own class
        const isTeacher = await EnrollmentRepository.isUserTeacher(userId, data.classId);
        if (isTeacher) {
            throw new EnrollmentError(
                'Guru tidak dapat mendaftar pada kelas yang dibuatnya sendiri',
                400
            );
        }

        // Prevent enrollment into classes not yet approved by Admin
        if (classData.approvalStatus !== class_approval_status.APPROVED) {
            throw new EnrollmentError('Kelas ini belum disetujui oleh Admin', 400);
        }

        // Check existing enrollment
        const existingEnrollment = await EnrollmentRepository.getUserEnrollment(userId, data.classId);
        if (existingEnrollment) {
            if (existingEnrollment.status === EnrollmentStatus.APPROVED) {
                throw new EnrollmentError('You are already enrolled in this class', 400);
            }
            if (existingEnrollment.status === EnrollmentStatus.PENDING) {
                throw new EnrollmentError('Pendaftaran Anda sedang menunggu persetujuan guru', 400);
            }
            // If REJECTED, allow re-enrollment (will update status below)
        }

        const targetStatus =
            classData.registrationType === RegistrationType.MANUAL
                ? EnrollmentStatus.PENDING
                : EnrollmentStatus.APPROVED;

        // Enroll user with status based on class registrationType
        return await EnrollmentRepository.enrollUser(userId, data.classId, targetStatus);
    }

    // Unenroll user from a class
    static async unenrollClass(userId: string, data: UnenrollClassInput) {
        // Check if class exists
        const classData = await EnrollmentRepository.getClassById(data.classId);
        if (!classData) {
            throw new EnrollmentError('Class not found', 404);
        }

        // Get user's enrollment
        const enrollment = await EnrollmentRepository.getUserEnrollment(userId, data.classId);
        if (!enrollment) {
            throw new EnrollmentError('You are not enrolled in this class', 400);
        }

        // Check if user is a student
        if (enrollment.role !== 'Student') {
            throw new EnrollmentError('Only students can unenroll from classes', 400);
        }

        // Unenroll user
        return await EnrollmentRepository.unenrollUser(userId, data.classId);
    }

    // Get user's enrolled classes
    static async getMyEnrolledClasses(
        userId: string,
        statusFilter: EnrollmentStatus | 'ALL' = EnrollmentStatus.APPROVED
    ) {
        return await EnrollmentRepository.getUserEnrolledClasses(userId, statusFilter);
    }

    // Check enrollment status
    static async checkEnrollment(userId: string, classId: number) {
        const enrollment = await EnrollmentRepository.getUserEnrollment(userId, classId);
        return {
            isEnrolled: enrollment?.status === EnrollmentStatus.APPROVED,
            status: enrollment?.status ?? null,
            enrollment: enrollment || null,
        };
    }

    // Get all student applicants in a class (Teacher of class / Admin only)
    static async getClassApplicants(
        classId: number,
        requesterId: string,
        requesterRole?: string,
        status?: EnrollmentStatus
    ) {
        const classData = await EnrollmentRepository.getClassById(classId);
        if (!classData) {
            throw new EnrollmentError('Class not found', 404);
        }

        if (requesterRole !== 'Admin') {
            const isTeacher = await EnrollmentRepository.isUserTeacher(requesterId, classId);
            if (!isTeacher) {
                throw new EnrollmentError(
                    'Anda tidak memiliki izin untuk mengelola pendaftar kelas ini',
                    403
                );
            }
        }

        return await EnrollmentRepository.getClassApplicants(classId, status);
    }

    // Approve or reject a student applicant (Teacher of class / Admin only)
    static async updateApplicantStatus(
        userClassId: number,
        data: UpdateApplicantStatusInput,
        requesterId: string,
        requesterRole?: string
    ) {
        const applicant = await EnrollmentRepository.getUserClassById(userClassId);
        if (!applicant) {
            throw new EnrollmentError('Data pendaftaran tidak ditemukan', 404);
        }

        if (applicant.role !== class_role.Student) {
            throw new EnrollmentError('Status hanya dapat diubah untuk pendaftar siswa', 400);
        }

        if (requesterRole !== 'Admin') {
            const isTeacher = await EnrollmentRepository.isUserTeacher(
                requesterId,
                applicant.classId
            );
            if (!isTeacher) {
                throw new EnrollmentError(
                    'Anda tidak memiliki izin untuk mengubah status pendaftar kelas ini',
                    403
                );
            }
        }

        return await EnrollmentRepository.updateEnrollmentStatus(
            userClassId,
            data.status as EnrollmentStatus
        );
    }
}
