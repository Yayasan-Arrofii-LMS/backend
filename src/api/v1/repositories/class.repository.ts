import { class_role } from "@prisma/client";
import prisma from "../../../database";
import { safeUserFields } from "./user.repository";

export const safeClassFields = {
    id: true,
    name: true,
    description: true,
    image_path: true,
    categoryId: true,
};

class ClassRepository {
    async getCount(userId?: string, search?: string, categoryId?: number) {
        const cat = categoryId ? { categoryId } : {};
        const q = search ? { OR: [{ name: { contains: search } }, { description: { contains: search } }] } : {};
        if (!userId) {
            return await prisma.class.count({ where: { ...cat, ...q } });
        }
        return await prisma.class.count({
            where: {
                ...cat,
                ...q,
                User_Class: { some: { userId: userId } },
            },
        });
    }

    async createClass(name: string, description: string, image_path: string, categoryId?: number | null) {
        const createdClass = await prisma.class.create({
            data: {
                name,
                description,
                image_path: image_path,
                categoryId: categoryId ?? null,
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
            teachers,
        };
    } async getClasses(skip: number = 0, take: number = 10, search?: string, userId?: string, categoryId?: number) {
        let classes;

        const cat = categoryId ? { categoryId } : {};
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
                where: { ...cat, ...q },
                select: { ...safeClassFields, category: { select: { id: true, name: true } } },
            });
        } else {
            classes = await prisma.class.findMany({
                where: {
                    ...cat,
                    ...q,
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
                select: { ...safeClassFields, category: { select: { id: true, name: true } } },
            });
        }
        return classes.map((classData) => {
            const appUrl = (process.env.APP_URL || "http://localhost").replace(/\/$/, "");
            const imagePathRelative = `${appUrl}/${classData.image_path}`.replace(/\/$/, "");

            return { ...classData, image_path_relative: imagePathRelative };
        });
    }
    async updateClass(classId: number, data: { name?: string; description?: string, image_path?: string, categoryId?: number | null }) {
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

    async getStudentsInClass(classId: number) {
        const students = await prisma.user.findMany({
            where: {
                User_Class: {
                    some: {
                        classId: classId,
                        role: class_role.Student
                    },
                }
            },
            select: safeUserFields
        });

        return students;
    }
}

export default new ClassRepository();