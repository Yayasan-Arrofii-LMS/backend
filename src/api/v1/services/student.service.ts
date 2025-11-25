import { EnrollmentRepository } from '../repositories/enrollment.repository';

class StudentService {
    async checkEnrollment(userId: string, classId: number): Promise<boolean> {
        return await EnrollmentRepository.isUserEnrolled(userId, classId);
    }
}

export default new StudentService();