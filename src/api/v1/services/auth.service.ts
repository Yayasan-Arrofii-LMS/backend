import bcrypt from 'bcrypt';
import { otp_type, Reset_Token, User } from '@prisma/client';
import prisma from '../../../database';
import { sendOTPEmail } from '../helpers/email';
import userService from './user.service';
import tokenService from './token.service';
import otpService from './otp.service';
import { registerUserDto } from '../schemas/auth.schema';

export class AuthService {
    async login(usernameoremail: string, password: string): Promise<{ user: User; isSameCredentials: boolean }> {
        const user = await userService.findUser({ username: usernameoremail }) || await userService.findUser({ email: usernameoremail });
        if (!user || !(await bcrypt.compare(password, user.password))) {
            throw new Error('Invalid credentials');
        }

        if (!user.verified_at) {
            throw new Error('Account not verified');
        }

        const isSameCredentials = (process.env.DEFAULT_PASSWORD || 'Password@123') === password;
        return { user, isSameCredentials };
    }

    async register({ name, email, password, username }: registerUserDto): Promise<Partial<User>> {
        if (!username) {
            username = email.split('@')[0];
        }
        const user = await userService.createUser({
            username,
            name,
            email,
            password: password,
            role: "Student",
        });

        const otp: string = await otpService.generateOTP(email, otp_type.EmailVerification);
        sendOTPEmail(email, otp, "verify your account");
        return user;
    }

    async forgotPassword(email: string): Promise<boolean> {
        const user = await userService.findUser({ email: email });
        if (!user) {
            return false;
        }
        const otp: string = await otpService.generateOTP(email, otp_type.PasswordReset);
        sendOTPEmail(email, otp, "reset your password");
        return true;
    }

    async resetPassword(reset_token: string, newPassword: string): Promise<void> {
        const user = await tokenService.findUserByToken(reset_token);
        if (!user) {
            throw new Error('Invalid or expired token');
        }
        const hashedPassword = await bcrypt.hash(newPassword, 10);
        await userService.updateUser(user.id, { password: hashedPassword });
    }

    async changePassword(
        userId: string,
        newPassword: string,
        currentPassword?: string
    ): Promise<void> {
        const user = await prisma.user.findUnique({ where: { id: userId } });
        if (!user) {
            throw new Error('User tidak ditemukan');
        }

        if (currentPassword !== undefined && currentPassword !== '') {
            const isMatch = await bcrypt.compare(currentPassword, user.password);
            if (!isMatch) {
                throw new Error('Kata sandi saat ini tidak cocok');
            }
        }

        const hashedPassword = await bcrypt.hash(newPassword, 10);
        await prisma.user.update({
            where: { id: userId },
            data: { password: hashedPassword },
        });
    }

    async verifyOTP(email: string, otp: string): Promise<string | null> {
        const user = await userService.findUser({ email: email });
        if (!user) {
            throw new Error('User not found');
        }
        const isValidOTP = await otpService.verifyOTP(email, otp);
        if (!isValidOTP) {
            throw new Error('Invalid or expired OTP');
        }
        const otpRecord = await otpService.findOTPByEmail(email);
        if (!otpRecord) {
            return null;
        }

        switch (otpRecord.type) {
            case otp_type.PasswordReset: {
                const resetToken: Reset_Token = await tokenService.generateToken({ userId: user.id });
                return resetToken.token;
            }

            case otp_type.EmailVerification: {
                await userService.updateUser(user.id, { verified_at: new Date() });
                return null;
            }

            default:
                return null;
        }
    }

    async resendOTP(email: string): Promise<void> {
        const user = await userService.findUser({ email: email });
        if (!user) {
            throw new Error('User not found');
        }
        const otp: string = await otpService.generateOTP(email, otp_type.EmailVerification);
        sendOTPEmail(email, otp, "verify your account");
    }
}