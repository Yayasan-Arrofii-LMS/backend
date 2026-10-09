import { class_role } from "@prisma/client";
import classRepository from "../repositories/class.repository";
import categoryRepository from "../repositories/category.repository";
import userService from "./user.service";
import userClassService from "./userClass.service";
import { BaseResponse } from "../types/responseType";

interface ClassData {
    name?: string;
    description?: string;
    image_path?: string;
    categoryId?: number | null;
}

class ClassService {
    async getClassCount() {
        return await classRepository.getCount();
    }

    async getClasses(userId: string, userRole: string | undefined, page: number, limit: number, search?: string, categoryId?: number) {
        const skip = (page - 1) * limit;

        // Admin can see all classes
        if (userRole === 'Admin') {
            const [classes, totalItems] = await Promise.all([
                classRepository.getClasses(skip, limit, search, undefined, categoryId),
                classRepository.getCount(undefined, search, categoryId),
            ]);
            return { classes, totalItems };
        }

        // Regular users see only their enrolled classes
        const [classes, totalItems] = await Promise.all([
            classRepository.getClasses(skip, limit, search, userId, categoryId),
            classRepository.getCount(userId, search, categoryId),
        ]);
        return { classes, totalItems };
    }

    async getClassById(classId: number) {
        return await classRepository.findClassById(classId);
    }

    async createClass(teacherId: string, data: { name: string; description: string, image_path: string, categoryId?: number | null }) {
        const user = await userService.getUserById(teacherId);
        if (!user) {
            throw new Error("User not found");
        }
        if (data.categoryId !== undefined && data.categoryId !== null) {
            const cat = await categoryRepository.findById(data.categoryId);
            if (!cat) throw new Error("Category not found");
        }

        const createdClass = await classRepository.createClass(data.name, data.description, data.image_path, data.categoryId ?? null);
        await userClassService.assignClass(user.id, createdClass.id, class_role.Teacher);

        return createdClass;
    }

    async updateClass(classId: number, data: ClassData) {
        const existingClass = await classRepository.findClassById(classId);
        if (!existingClass) {
            return null;
        }
        if (data.categoryId !== undefined && data.categoryId !== null) {
            const cat = await categoryRepository.findById(data.categoryId);
            if (!cat) throw new Error("Category not found");
        }

        return await classRepository.updateClass(classId, {
            name: data.name || existingClass.name,
            description: data.description || existingClass.description,
            image_path: data.image_path || existingClass.image_path,
            categoryId: data.categoryId !== undefined ? data.categoryId : (existingClass as any).categoryId ?? null,
        });
    }

    async deleteClass(classId: number) {
        const existingClass = await classRepository.findClassById(classId);
        if (!existingClass) {
            return false;
        }

        await classRepository.deleteClass(classId);
        return true;
    }

    async getAllStudentsInClass(classId: number) {
        return await classRepository.getStudentsInClass(classId);
    }

    async getAllClasses(data: { search?: string; limit?: number; page?: number; categoryId?: number }) {
        const { search, limit = 12, page = 1, categoryId } = data;
        const skip = (page - 1) * limit;
        const classes = await classRepository.getClasses(skip, limit, search, undefined, categoryId);
        const totalItems = await classRepository.getCount(undefined, search, categoryId);

        const meta: BaseResponse<any>["meta"] = {
            totalItems,
            itemsPerPage: limit,
            totalPages: limit ? Math.ceil(totalItems / limit) : 1,
            currentPage: page
        };

        return { classes, meta };
    }
}

export default new ClassService();