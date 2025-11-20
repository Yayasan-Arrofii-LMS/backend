import { env } from "process";
import { NotFoundError } from "../errors/notfound.error";
import profileRepository from "../repositories/profile.repository";

interface UpdateProfileData {
    name?: string;
    username?: string;
    telp?: string;
    bio?: string;
    profileImage?: string;
    specialization?: string;
}

class ProfileService {
    async getProfile(userId: string) {
        const user = await profileRepository.getUserProfile(userId);
        if (!user) {
            throw new NotFoundError("User not found");
        }

        // Base profile data
        const profile: Record<string, unknown> = {
            id: user.id,
            email: user.email,
            username: user.username,
            name: user.name,
            profileImage: `${env.APP_URL}/${user.profileImage}`,
            role: user.role.name,
            createdAt: user.createdAt,
            updatedAt: user.updatedAt,
        };
        return profile;
    }

    async updateProfile(userId: string, data: UpdateProfileData) {
        // Check if user exists
        const existingUser = await profileRepository.getUserProfile(userId);
        if (!existingUser) {
            throw new NotFoundError("User not found");
        }

        // Check if username is being changed and if it's already taken
        if (data.username && data.username !== existingUser.username) {
            const usernameExists = await profileRepository.checkUsernameExists(data.username, userId);
            if (usernameExists) {
                throw new Error("Username already taken");
            }
        }

        // Update profile
        const updatedUser = await profileRepository.updateProfile(userId, data);

        // Build response with role-specific fields
        const profile: Record<string, unknown> = {
            id: updatedUser.id,
            email: updatedUser.email,
            username: updatedUser.username,
            name: updatedUser.name,
            profileImage: `${env.APP_URL}/${updatedUser.profileImage}`,
            role: updatedUser.role.name,
            createdAt: updatedUser.createdAt,
            updatedAt: updatedUser.updatedAt,
        };
        return profile;
    }

    async deleteProfile(userId: string) {
        const user = await profileRepository.getUserProfile(userId);
        if (!user) {
            throw new NotFoundError("User not found");
        }

        await profileRepository.deleteProfile(userId);
        return { message: "Profile deleted successfully" };
    }
}

export default new ProfileService();
