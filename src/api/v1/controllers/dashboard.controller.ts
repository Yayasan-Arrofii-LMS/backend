import { Request, Response } from "express";
import { sendResponse } from "../helpers/baseResponse";
import dashboardService, { DashboardQueryParams } from "../services/dashboard.service";

export const getHomeData = async (req: Request, res: Response) => {
    try {
        const params: DashboardQueryParams = {
            period: typeof req.query.period === "string" ? req.query.period : undefined,
            year: typeof req.query.year === "string" ? req.query.year : undefined,
            month: typeof req.query.month === "string" ? req.query.month : undefined,
            startDate: typeof req.query.startDate === "string" ? req.query.startDate : undefined,
            endDate: typeof req.query.endDate === "string" ? req.query.endDate : undefined,
        };

        const data = await dashboardService.getDashboardData(params);
        sendResponse({
            res,
            statusCode: 200,
            success: true,
            message: "dashboard fetched successfully",
            data,
        });
    } catch (error) {
        console.error("Error fetching dashboard:", error);
        sendResponse({
            res,
            statusCode: 500,
            success: false,
            message: "Error fetching dashboard",
            data: null,
        });
    }
};