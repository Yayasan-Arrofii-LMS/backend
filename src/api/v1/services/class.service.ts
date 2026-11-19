import { class_approval_status, class_role, RegistrationType } from "@prisma/client";
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
    registrationType?: RegistrationType;
}

class ClassService {
    async getClassCount() {
        return await classRepository.getCount();
    }

    async getClasses(
        userId: string,
        userRole: string | undefined,
        page: number,
        limit: number,
        search?: string,
        categoryId?: number | string,
        approvalStatus?: class_approval_status
    ) {
        const skip = (page - 1) * limit;

        // Admin can see all classes (optionally filtered by approvalStatus)
        if (userRole === 'Admin') {
            const [classes, totalItems] = await Promise.all([
                classRepository.getClasses(skip, limit, search, undefined, categoryId, approvalStatus),
                classRepository.getCount(undefined, search, categoryId, approvalStatus),
            ]);
            return { classes, totalItems };
        }

        // Regular teachers see only their own classes (all statuses so they can track pending/rejected)
        const [classes, totalItems] = await Promise.all([
            classRepository.getClasses(skip, limit, search, userId, categoryId, approvalStatus),
            classRepository.getCount(userId, search, categoryId, approvalStatus),
        ]);
        return { classes, totalItems };
    }

    async getPendingClasses(page: number = 1, limit: number = 12, search?: string) {
        const skip = (page - 1) * limit;
        const [classes, totalItems] = await Promise.all([
            classRepository.getClasses(skip, limit, search, undefined, undefined, class_approval_status.PENDING),
            classRepository.getCount(undefined, search, undefined, class_approval_status.PENDING),
        ]);
        return { classes, totalItems };
    }

    async getClassById(classId: number) {
        return await classRepository.findClassById(classId);
    }

    async createClass(
        creatorId: string,
        data: { name: string; description: string, image_path: string, categoryId?: number | null, registrationType?: RegistrationType },
        creatorRole?: string
    ) {
        const user = await userService.getUserById(creatorId);
        if (!user) {
            throw new Error("User not found");
        }
        if (data.categoryId !== undefined && data.categoryId !== null) {
            const cat = await categoryRepository.findById(data.categoryId);
            if (!cat) throw new Error("Category not found");
        }

        const isAdmin = creatorRole === "Admin";
        const approvalStatus = isAdmin ? class_approval_status.APPROVED : class_approval_status.PENDING;
        const approvedById = isAdmin ? creatorId : null;
        const approvedAt = isAdmin ? new Date() : null;

        const createdClass = await classRepository.createClass(
            data.name,
            data.description,
            data.image_path,
            data.categoryId ?? null,
            data.registrationType,
            approvalStatus,
            approvedById,
            approvedAt
        );
        await userClassService.assignClass(user.id, createdClass.id, class_role.Teacher);

        return createdClass;
    }

    async approveClass(adminId: string, classId: number) {
        const existingClass = await classRepository.findClassById(classId);
        if (!existingClass) {
            return null;
        }
        return await classRepository.updateApprovalStatus(
            classId,
            class_approval_status.APPROVED,
            adminId,
            null
        );
    }

    async rejectClass(adminId: string, classId: number, reason?: string) {
        const existingClass = await classRepository.findClassById(classId);
        if (!existingClass) {
            return null;
        }
        return await classRepository.updateApprovalStatus(
            classId,
            class_approval_status.REJECTED,
            adminId,
            reason ?? null
        );
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
            registrationType: data.registrationType ?? existingClass.registrationType,
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

    async getAllClasses(data: { search?: string; limit?: number; page?: number; categoryId?: number | string }) {
        const { search, limit = 12, page = 1, categoryId } = data;
        const skip = (page - 1) * limit;
        const classes = await classRepository.getClasses(
            skip,
            limit,
            search,
            undefined,
            categoryId,
            class_approval_status.APPROVED
        );
        const totalItems = await classRepository.getCount(
            undefined,
            search,
            categoryId,
            class_approval_status.APPROVED
        );

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