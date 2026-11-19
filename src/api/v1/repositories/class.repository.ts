import { class_approval_status, class_role, EnrollmentStatus, RegistrationType } from "@prisma/client";
import prisma from "../../../database";
import { safeUserFields } from "./user.repository";

export const safeClassFields = {
    id: true,
    name: true,
    description: true,
    image_path: true,
    categoryId: true,
    registrationType: true,
    approvalStatus: true,
    rejectionReason: true,
    approvedById: true,
    approvedAt: true,
    createdAt: true,
    updatedAt: true,
};

class ClassRepository {
    private buildCategoryWhere(categoryId?: number | string) {
        if (categoryId === undefined || categoryId === null || categoryId === "" || categoryId === "Semua") {
            return {};
        }
        if (typeof categoryId === "number") {
            return { categoryId };
        }
        const trimmed = categoryId.trim();
        if (!trimmed || trimmed === "Semua") {
            return {};
        }
        const num = Number(trimmed);
        if (!Number.isNaN(num)) {
            return { categoryId: num };
        }
        return { category: { name: trimmed } };
    }

    async getCount(
        userId?: string,
        search?: string,
        categoryId?: number | string,
        approvalStatus?: class_approval_status
    ) {
        const cat = this.buildCategoryWhere(categoryId);
        const q = search
            ? {
                  OR: [
                      { name: { contains: search } },
                      { description: { contains: search } },
                      {
                          User_Class: {
                              some: {
                                  role: class_role.Teacher,
                                  user: { name: { contains: search } },
                              },
                          },
                      },
                  ],
              }
            : {};
        const approval = approvalStatus ? { approvalStatus } : {};
        if (!userId) {
            return await prisma.class.count({ where: { ...cat, ...q, ...approval } });
        }
        return await prisma.class.count({
            where: {
                ...cat,
                ...q,
                ...approval,
                User_Class: { some: { userId: userId, role: class_role.Teacher } },
            },
        });
    }

    async createClass(
        name: string,
        description: string,
        image_path: string,
        categoryId?: number | null,
        registrationType?: RegistrationType,
        approvalStatus: class_approval_status = class_approval_status.APPROVED,
        approvedById?: string | null,
        approvedAt?: Date | null
    ) {
        const createdClass = await prisma.class.create({
            data: {
                name,
                description,
                image_path: image_path,
                categoryId: categoryId ?? null,
                ...(registrationType ? { registrationType } : {}),
                approvalStatus,
                approvedById: approvedById ?? null,
                approvedAt: approvedAt ?? null,
            },
            select: safeClassFields
        });

        return { ...createdClass, image_path_relative: `${(process.env.APP_URL || "http://localhost").replace(/\/$/, "")}/${createdClass.image_path}`.replace(/\/$/, "") };
    }


    async findClassById(classId: number) {
        const classData = await prisma.class.findFirst({
            where: { id: classId },
            select: {
                ...safeClassFields,
                category: { select: { id: true, name: true } },
                approver: { select: { id: true, name: true, email: true } },
                User_Class: {
                    where: {
                        role: class_role.Teacher,
                    },
                    select: {
                        user: {
                            select: {
                                id: true,
                                name: true,
                                email: true,
                            },
                        },
                    },
                },
            },
        });

        if (!classData) return null;

        const appUrl = (process.env.APP_URL || "http://localhost:3001").replace(/\/$/, "");
        const imagePathRelative = `${appUrl}/${classData.image_path}`.replace(/\/$/, "");

        const teachers = classData.User_Class.map(uc => uc.user);

        return {
            id: classData.id,
            name: classData.name,
            description: classData.description,
            image_path: classData.image_path,
            image_path_relative: imagePathRelative,
            categoryId: classData.categoryId,
            category: (classData as any).category ?? null,
            registrationType: classData.registrationType,
            approvalStatus: classData.approvalStatus,
            rejectionReason: classData.rejectionReason,
            approvedById: classData.approvedById,
            approvedAt: classData.approvedAt,
            createdAt: classData.createdAt,
            updatedAt: classData.updatedAt,
            approver: classData.approver ?? null,
            teachers,
        };
    }

    async getClasses(
        skip: number = 0,
        take: number = 10,
        search?: string,
        userId?: string,
        categoryId?: number | string,
        approvalStatus?: class_approval_status
    ) {
        let classes;

        const cat = this.buildCategoryWhere(categoryId);
        const approval = approvalStatus ? { approvalStatus } : {};
        const q = search ? {
            OR: [
                {
                    name: {
                        contains: search,
                    }
                },
                {
                    description: {
                        contains: search,
                    }
                },
                {
                    User_Class: {
                        some: {
                            role: class_role.Teacher,
                            user: {
                                name: {
                                    contains: search,
                                }
                            }
                        }
                    }
                }
            ]
        } : {};
        if (!userId) {
            classes = await prisma.class.findMany({
                skip,
                take,
                orderBy: {
                    createdAt: "desc",
                },
                where: { ...cat, ...q, ...approval },
                select: {
                    ...safeClassFields,
                    category: { select: { id: true, name: true } },
                    User_Class: {
                        where: { role: class_role.Teacher },
                        select: {
                            user: { select: { id: true, name: true, email: true } },
                        },
                    },
                },
            });
        } else {
            classes = await prisma.class.findMany({
                where: {
                    ...cat,
                    ...q,
                    ...approval,
                    User_Class: {
                        some: {
                            userId: userId,
                            role: class_role.Teacher,
                        }
                    },
                },
                skip,
                take,
                orderBy: {
                    createdAt: "desc",
                },
                select: {
                    ...safeClassFields,
                    category: { select: { id: true, name: true } },
                    User_Class: {
                        where: { role: class_role.Teacher },
                        select: {
                            user: { select: { id: true, name: true, email: true } },
                        },
                    },
                },
            });
        }
        return classes.map((classData) => {
            const appUrl = (process.env.APP_URL || "http://localhost").replace(/\/$/, "");
            const imagePathRelative = `${appUrl}/${classData.image_path}`.replace(/\/$/, "");
            const { User_Class, ...rest } = classData;
            const teachers = User_Class.map((uc) => uc.user);

            return { ...rest, teachers, image_path_relative: imagePathRelative };
        });
    }
    async updateClass(classId: number, data: { name?: string; description?: string, image_path?: string, categoryId?: number | null, registrationType?: RegistrationType }) {
        return await prisma.class.update({
            where: { id: classId },
            data,
        });
    }

    async deleteClass(classId: number) {
        await prisma.class.delete({
            where: { id: classId },
        });
    }

    async updateApprovalStatus(
        classId: number,
        status: class_approval_status,
        adminId: string,
        reason?: string | null
    ) {
        const updated = await prisma.class.update({
            where: { id: classId },
            data: {
                approvalStatus: status,
                rejectionReason: status === class_approval_status.REJECTED ? (reason ?? null) : null,
                approvedById: adminId,
                approvedAt: new Date(),
            },
            select: {
                ...safeClassFields,
                category: { select: { id: true, name: true } },
                approver: { select: { id: true, name: true, email: true } },
            },
        });
        const appUrl = (process.env.APP_URL || "http://localhost").replace(/\/$/, "");
        const imagePathRelative = `${appUrl}/${updated.image_path}`.replace(/\/$/, "");
        return { ...updated, image_path_relative: imagePathRelative };
    }

    async getStudentsInClass(classId: number) {
        const students = await prisma.user.findMany({
            where: {
                User_Class: {
                    some: {
                        classId: classId,
                        role: class_role.Student,
                        status: EnrollmentStatus.APPROVED,
                    },
                }
            },
            select: safeUserFields
        });

        return students;
    }
}

export default new ClassRepository();