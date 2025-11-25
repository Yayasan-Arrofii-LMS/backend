import prisma from '../../../database';
import { class_role } from '@prisma/client';

export class EnrollmentRepository {
    // Check if user is enrolled in a class
    static async isUserEnrolled(userId: string, classId: number) {
        const enrollment = await prisma.user_Class.findUnique({
            where: {
                userId_classId: {
                    userId,
                    classId,
                },
            },
        });
        return !!enrollment;
    }

    // Get user's enrollment in a class
    static async getUserEnrollment(userId: string, classId: number) {
        return await prisma.user_Class.findUnique({
            where: {
                userId_classId: {
                    userId,
                    classId,
                },
            },
            include: {
                class: true,
                user: {
                    select: {
                        id: true,
                        name: true,
                        email: true,
                        username: true,
                        profileImage: true,
                    },
                },
            },
        });
    }

    // Enroll user to a class
    static async enrollUser(userId: string, classId: number) {
        return await prisma.user_Class.create({
            data: {
                userId,
                classId,
                role: class_role.Student,
            },
            include: {
                class: true,
                user: {
                    select: {
                        id: true,
                        name: true,
                        email: true,
                        username: true,
                        profileImage: true,
                    },
                },
            },
        });
    }

    // Unenroll user from a class
    static async unenrollUser(userId: string, classId: number) {
        return await prisma.user_Class.delete({
            where: {
                userId_classId: {
                    userId,
                    classId,
                },
            },
        });
    }

    // Get all user's enrolled classes
    static async getUserEnrolledClasses(userId: string) {
        return await prisma.user_Class.findMany({
            where: {
                userId,
                role: class_role.Student,
            },
            include: {
                class: {
                    include: {
                        Section: {
                            select: {
                                id: true,
                                title: true,
                            },
                        },
                        _count: {
                            select: {
                                User_Class: true,
                            },
                        },
                    },
                },
            },
            orderBy: {
                createdAt: 'desc',
            },
        });
    }

    // Get class with enrollment count
    static async getClassById(classId: number) {
        return await prisma.class.findUnique({
            where: { id: classId },
            include: {
                _count: {
                    select: {
                        User_Class: true,
                    },
                },
            },
        });
    }

    // Check if user is a teacher in a class
    static async isUserTeacher(userId: string, classId: number) {
        const enrollment = await prisma.user_Class.findUnique({
            where: {
                userId_classId: {
                    userId,
                    classId,
                },
            },
        });
        return enrollment?.role === class_role.Teacher || enrollment?.role === class_role.Admin;
    }
}
