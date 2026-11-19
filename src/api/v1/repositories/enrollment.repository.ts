import prisma from '../../../database';
import { class_role, EnrollmentStatus } from '@prisma/client';

export class EnrollmentRepository {
    // Check if user is enrolled (and approved) in a class
    static async isUserEnrolled(userId: string, classId: number) {
        const enrollment = await prisma.user_Class.findUnique({
            where: {
                userId_classId: {
                    userId,
                    classId,
                },
            },
        });
        return enrollment?.status === EnrollmentStatus.APPROVED;
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

    // Enroll user to a class (upsert allows re-enrollment after REJECTED)
    static async enrollUser(
        userId: string,
        classId: number,
        status: EnrollmentStatus = EnrollmentStatus.APPROVED
    ) {
        return await prisma.user_Class.upsert({
            where: {
                userId_classId: {
                    userId,
                    classId,
                },
            },
            update: {
                role: class_role.Student,
                status,
            },
            create: {
                userId,
                classId,
                role: class_role.Student,
                status,
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
    static async getUserEnrolledClasses(
        userId: string,
        statusFilter: EnrollmentStatus | 'ALL' = EnrollmentStatus.APPROVED
    ) {
        const enrollments = await prisma.user_Class.findMany({
            where: {
                userId,
                role: class_role.Student,
                ...(statusFilter !== 'ALL' ? { status: statusFilter } : {}),
            },
            include: {
                class: {
                    include: {
                        Section: {
                            select: {
                                id: true,
                                title: true,
                                Material: {
                                    select: {
                                        id: true,
                                    },
                                },
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

        const allMaterialIds = enrollments.flatMap((e) =>
            e.class.Section.flatMap((s) => s.Material.map((m) => m.id))
        );

        const completedMaterialIds = new Set<number>();

        if (allMaterialIds.length > 0) {
            const [userMaterials, activities] = await Promise.all([
                prisma.user_Material.findMany({
                    where: {
                        userId,
                        is_completed: true,
                        materialId: { in: allMaterialIds },
                    },
                    select: { materialId: true },
                }),
                prisma.materialActivity.findMany({
                    where: {
                        userId,
                        action: { in: ['completed', 'opened'] },
                        materialId: { in: allMaterialIds },
                    },
                    select: { materialId: true },
                }),
            ]);

            userMaterials.forEach((um) => completedMaterialIds.add(um.materialId));
            activities.forEach((act) => completedMaterialIds.add(act.materialId));
        }

        return enrollments.map((enrollment) => {
            const classMaterialIds = enrollment.class.Section.flatMap((s) =>
                s.Material.map((m) => m.id)
            );
            const totalMaterials = classMaterialIds.length;
            const completedCount = classMaterialIds.filter((id) =>
                completedMaterialIds.has(id)
            ).length;
            const progress =
                totalMaterials > 0
                    ? Math.round((completedCount / totalMaterials) * 100)
                    : 0;

            return {
                ...enrollment,
                progress,
                progressPercentage: progress,
                class: {
                    ...enrollment.class,
                    progress,
                },
            };
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

    // Get all student applicants in a class
    static async getClassApplicants(classId: number, status?: EnrollmentStatus) {
        return await prisma.user_Class.findMany({
            where: {
                classId,
                role: class_role.Student,
                ...(status ? { status } : {}),
            },
            include: {
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
            orderBy: {
                createdAt: 'desc',
            },
        });
    }

    // Get a User_Class record by ID
    static async getUserClassById(id: number) {
        return await prisma.user_Class.findUnique({
            where: { id },
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

    // Update enrollment status of a User_Class record
    static async updateEnrollmentStatus(id: number, status: EnrollmentStatus) {
        return await prisma.user_Class.update({
            where: { id },
            data: { status },
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
}
