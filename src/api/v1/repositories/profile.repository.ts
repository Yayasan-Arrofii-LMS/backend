import prisma from "../../../database";

class ProfileRepository {
    async getUserProfile(userId: string) {
        return await prisma.user.findUnique({
            where: { id: userId },
            select: {
                id: true,
                email: true,
                username: true,
                name: true,
                profileImage: true,
                createdAt: true,
                updatedAt: true,
                role: {
                    select: {
                        id: true,
                        name: true,
                    },
                },
            },
        });
    }

    async updateProfile(userId: string, data: {
        name?: string;
        username?: string;
        telp?: string;
        bio?: string;
        profileImage?: string;
        specialization?: string;
    }) {
        return await prisma.user.update({
            where: { id: userId },
            data,
            select: {
                id: true,
                email: true,
                username: true,
                name: true,
                profileImage: true,
                createdAt: true,
                updatedAt: true,
                role: {
                    select: {
                        id: true,
                        name: true,
                    },
                },
            },
        });
    }

    async deleteProfile(userId: string) {
        return await prisma.user.delete({
            where: { id: userId },
        });
    }

    async checkUsernameExists(username: string, excludeUserId?: string) {
        return await prisma.user.findFirst({
            where: {
                username,
                ...(excludeUserId && { id: { not: excludeUserId } }),
            },
        });
    }
}

export default new ProfileRepository();
