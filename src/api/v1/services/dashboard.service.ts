import dashboardRepository, { DateRangeWindow } from "../repositories/dashboard.repository";

export type DashboardPeriodPreset =
    | "today"
    | "7d"
    | "30d"
    | "this_month"
    | "last_month"
    | "this_year"
    | "last_year"
    | "custom";

export interface DashboardQueryParams {
    period?: DashboardPeriodPreset | string;
    year?: number | string;
    month?: number | string;
    startDate?: string;
    endDate?: string;
}

export interface MetricWithChange {
    current: number;
    previous: number;
    changePercent: number;
    totalCumulative?: number;
}

export interface PeriodInfo {
    label: string;
    granularity: "day" | "month";
    startDate: string;
    endDate: string;
    previousStartDate: string;
    previousEndDate: string;
}

export interface TimelineDataPoint {
    label: string;
    date: string;
    students: number;
    teachers: number;
    classes: number;
    materials: number;
    quizAttempts: number;
    assignments: number;
    workshopRegistrations: number;
}

const MONTH_NAMES_ID = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
];

const SHORT_MONTH_NAMES_ID = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "Mei",
    "Jun",
    "Jul",
    "Agu",
    "Sep",
    "Okt",
    "Nov",
    "Des",
];

function startOfDay(d: Date): Date {
    return new Date(d.getFullYear(), d.getMonth(), d.getDate(), 0, 0, 0, 0);
}

function endOfDay(d: Date): Date {
    return new Date(d.getFullYear(), d.getMonth(), d.getDate(), 23, 59, 59, 999);
}

function formatDateKey(d: Date): string {
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, "0");
    const day = String(d.getDate()).padStart(2, "0");
    return `${y}-${m}-${day}`;
}

function formatMonthKey(d: Date): string {
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, "0");
    return `${y}-${m}`;
}

function formatShortDateId(d: Date): string {
    return `${d.getDate()} ${SHORT_MONTH_NAMES_ID[d.getMonth()]} ${d.getFullYear()}`;
}

function calculateChangePercent(current: number, previous: number): number {
    if (previous === 0) {
        return current > 0 ? 100 : 0;
    }
    return Math.round(((current - previous) / previous) * 100);
}

interface ResolvedPeriod extends DateRangeWindow {
    label: string;
    granularity: "day" | "month";
}

function parseDateInput(raw?: string): Date | null {
    if (!raw || typeof raw !== "string") return null;
    const trimmed = raw.trim();
    if (!trimmed) return null;
    // Handle YYYY-MM-DD in local time to avoid UTC off-by-one shifts
    const ymdMatch = /^(\d{4})-(\d{2})-(\d{2})$/.exec(trimmed);
    if (ymdMatch) {
        const y = Number(ymdMatch[1]);
        const m = Number(ymdMatch[2]);
        const day = Number(ymdMatch[3]);
        const dt = new Date(y, m - 1, day);
        return Number.isNaN(dt.getTime()) ? null : dt;
    }
    const parsed = new Date(trimmed);
    return Number.isNaN(parsed.getTime()) ? null : parsed;
}

class DashboardService {
    resolveDateRange(params: DashboardQueryParams = {}): ResolvedPeriod {
        const now = new Date();
        const rawPeriod = typeof params.period === "string" ? params.period.trim().toLowerCase() : undefined;

        const parsedYear =
            params.year !== undefined && params.year !== "" && params.year !== "all"
                ? Number(params.year)
                : NaN;
        const hasValidYear = Number.isInteger(parsedYear) && parsedYear >= 1970 && parsedYear <= 2100;

        const parsedMonth =
            params.month !== undefined && params.month !== "" && params.month !== "all"
                ? Number(params.month)
                : NaN;
        const hasValidMonth = Number.isInteger(parsedMonth) && parsedMonth >= 1 && parsedMonth <= 12;

        // 1. Custom date range (period=custom or explicit startDate & endDate)
        const customStart = parseDateInput(params.startDate);
        const customEnd = parseDateInput(params.endDate);
        if (rawPeriod === "custom" || (customStart && customEnd && !rawPeriod)) {
            if (customStart && customEnd) {
                const orderedStart = customStart <= customEnd ? startOfDay(customStart) : startOfDay(customEnd);
                const orderedEnd = customStart <= customEnd ? endOfDay(customEnd) : endOfDay(customStart);
                const durationMs = orderedEnd.getTime() - orderedStart.getTime() + 1;
                const previousEndDate = new Date(orderedStart.getTime() - 1);
                const previousStartDate = new Date(previousEndDate.getTime() - durationMs + 1);
                const spanDays = Math.ceil(durationMs / (1000 * 60 * 60 * 24));
                const granularity: "day" | "month" = spanDays <= 62 ? "day" : "month";
                return {
                    startDate: orderedStart,
                    endDate: orderedEnd,
                    previousStartDate,
                    previousEndDate,
                    granularity,
                    label: `${formatShortDateId(orderedStart)} - ${formatShortDateId(orderedEnd)}`,
                };
            }
        }

        // 2. Specific month (with or without explicit year) when no preset overrides it
        if (!rawPeriod && hasValidMonth) {
            const targetYear = hasValidYear ? parsedYear : now.getFullYear();
            const monthIdx = parsedMonth - 1;
            const startDate = new Date(targetYear, monthIdx, 1, 0, 0, 0, 0);
            const endDate = new Date(targetYear, monthIdx + 1, 0, 23, 59, 59, 999);
            const previousStartDate = new Date(targetYear, monthIdx - 1, 1, 0, 0, 0, 0);
            const previousEndDate = new Date(targetYear, monthIdx, 0, 23, 59, 59, 999);
            return {
                startDate,
                endDate,
                previousStartDate,
                previousEndDate,
                granularity: "day",
                label: `${MONTH_NAMES_ID[monthIdx]} ${targetYear}`,
            };
        }

        // 3. Specific year only (no month, no preset)
        if (!rawPeriod && hasValidYear) {
            const startDate = new Date(parsedYear, 0, 1, 0, 0, 0, 0);
            const endDate = new Date(parsedYear, 11, 31, 23, 59, 59, 999);
            const previousStartDate = new Date(parsedYear - 1, 0, 1, 0, 0, 0, 0);
            const previousEndDate = new Date(parsedYear - 1, 11, 31, 23, 59, 59, 999);
            return {
                startDate,
                endDate,
                previousStartDate,
                previousEndDate,
                granularity: "month",
                label: `Tahun ${parsedYear}`,
            };
        }

        // 4. Preset periods
        switch (rawPeriod) {
            case "today": {
                const startDate = startOfDay(now);
                const endDate = endOfDay(now);
                const yesterday = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 1);
                return {
                    startDate,
                    endDate,
                    previousStartDate: startOfDay(yesterday),
                    previousEndDate: endOfDay(yesterday),
                    granularity: "day",
                    label: `Hari Ini (${formatShortDateId(now)})`,
                };
            }
            case "7d": {
                const endDate = endOfDay(now);
                const startDate = startOfDay(new Date(now.getFullYear(), now.getMonth(), now.getDate() - 6));
                const previousEndDate = endOfDay(new Date(now.getFullYear(), now.getMonth(), now.getDate() - 7));
                const previousStartDate = startOfDay(new Date(now.getFullYear(), now.getMonth(), now.getDate() - 13));
                return {
                    startDate,
                    endDate,
                    previousStartDate,
                    previousEndDate,
                    granularity: "day",
                    label: "7 Hari Terakhir",
                };
            }
            case "30d": {
                const endDate = endOfDay(now);
                const startDate = startOfDay(new Date(now.getFullYear(), now.getMonth(), now.getDate() - 29));
                const previousEndDate = endOfDay(new Date(now.getFullYear(), now.getMonth(), now.getDate() - 30));
                const previousStartDate = startOfDay(new Date(now.getFullYear(), now.getMonth(), now.getDate() - 59));
                return {
                    startDate,
                    endDate,
                    previousStartDate,
                    previousEndDate,
                    granularity: "day",
                    label: "30 Hari Terakhir",
                };
            }
            case "this_month": {
                const y = now.getFullYear();
                const m = now.getMonth();
                return {
                    startDate: new Date(y, m, 1, 0, 0, 0, 0),
                    endDate: new Date(y, m + 1, 0, 23, 59, 59, 999),
                    previousStartDate: new Date(y, m - 1, 1, 0, 0, 0, 0),
                    previousEndDate: new Date(y, m, 0, 23, 59, 59, 999),
                    granularity: "day",
                    label: `${MONTH_NAMES_ID[m]} ${y}`,
                };
            }
            case "last_month": {
                const target = new Date(now.getFullYear(), now.getMonth() - 1, 1);
                const y = target.getFullYear();
                const m = target.getMonth();
                return {
                    startDate: new Date(y, m, 1, 0, 0, 0, 0),
                    endDate: new Date(y, m + 1, 0, 23, 59, 59, 999),
                    previousStartDate: new Date(y, m - 1, 1, 0, 0, 0, 0),
                    previousEndDate: new Date(y, m, 0, 23, 59, 59, 999),
                    granularity: "day",
                    label: `${MONTH_NAMES_ID[m]} ${y}`,
                };
            }
            case "last_year": {
                const y = now.getFullYear() - 1;
                return {
                    startDate: new Date(y, 0, 1, 0, 0, 0, 0),
                    endDate: new Date(y, 11, 31, 23, 59, 59, 999),
                    previousStartDate: new Date(y - 1, 0, 1, 0, 0, 0, 0),
                    previousEndDate: new Date(y - 1, 11, 31, 23, 59, 59, 999),
                    granularity: "month",
                    label: `Tahun ${y}`,
                };
            }
            case "this_year":
            default: {
                const y = now.getFullYear();
                return {
                    startDate: new Date(y, 0, 1, 0, 0, 0, 0),
                    endDate: new Date(y, 11, 31, 23, 59, 59, 999),
                    previousStartDate: new Date(y - 1, 0, 1, 0, 0, 0, 0),
                    previousEndDate: new Date(y - 1, 11, 31, 23, 59, 59, 999),
                    granularity: "month",
                    label: `Tahun ${y}`,
                };
            }
        }
    }

    private buildTimeline(
        startDate: Date,
        endDate: Date,
        granularity: "day" | "month",
        raw: {
            learnerDates: Date[];
            teacherDates: Date[];
            classDates: Date[];
            materialDates: Date[];
            quizAttemptDates: Date[];
            assignmentDates: Date[];
            workshopRegistrationDates: Date[];
        }
    ): TimelineDataPoint[] {
        const buckets = new Map<string, TimelineDataPoint>();
        const multiYear = startDate.getFullYear() !== endDate.getFullYear();

        if (granularity === "day") {
            const cursor = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate());
            const endCursor = new Date(endDate.getFullYear(), endDate.getMonth(), endDate.getDate());
            while (cursor <= endCursor) {
                const key = formatDateKey(cursor);
                buckets.set(key, {
                    label: `${cursor.getDate()} ${SHORT_MONTH_NAMES_ID[cursor.getMonth()]}`,
                    date: key,
                    students: 0,
                    teachers: 0,
                    classes: 0,
                    materials: 0,
                    quizAttempts: 0,
                    assignments: 0,
                    workshopRegistrations: 0,
                });
                cursor.setDate(cursor.getDate() + 1);
            }
        } else {
            const cursor = new Date(startDate.getFullYear(), startDate.getMonth(), 1);
            const endCursor = new Date(endDate.getFullYear(), endDate.getMonth(), 1);
            while (cursor <= endCursor) {
                const key = formatMonthKey(cursor);
                const shortMonth = SHORT_MONTH_NAMES_ID[cursor.getMonth()];
                const shortYear = String(cursor.getFullYear()).slice(-2);
                buckets.set(key, {
                    label: multiYear ? `${shortMonth} ${shortYear}` : shortMonth,
                    date: key,
                    students: 0,
                    teachers: 0,
                    classes: 0,
                    materials: 0,
                    quizAttempts: 0,
                    assignments: 0,
                    workshopRegistrations: 0,
                });
                cursor.setMonth(cursor.getMonth() + 1);
            }
        }

        const keyOf = (d: Date) => (granularity === "day" ? formatDateKey(d) : formatMonthKey(d));

        const increment = (
            dates: Date[],
            field: keyof Omit<TimelineDataPoint, "label" | "date">
        ) => {
            for (const d of dates) {
                const bucket = buckets.get(keyOf(d));
                if (bucket) {
                    bucket[field] += 1;
                }
            }
        };

        increment(raw.learnerDates, "students");
        increment(raw.teacherDates, "teachers");
        increment(raw.classDates, "classes");
        increment(raw.materialDates, "materials");
        increment(raw.quizAttemptDates, "quizAttempts");
        increment(raw.assignmentDates, "assignments");
        increment(raw.workshopRegistrationDates, "workshopRegistrations");

        return Array.from(buckets.values());
    }

    private buildInsights(
        periodLabel: string,
        studentsDelta: MetricWithChange,
        quizAvg: MetricWithChange,
        actionItems: {
            pendingClasses: number;
            pendingWorkshops: number;
            pendingWorkshopParticipants: number;
            pendingQuizGrading: number;
            pendingAssignmentGrading: number;
            totalPending: number;
        }
    ): string[] {
        const insights: string[] = [];

        if (studentsDelta.current > 0) {
            const trend =
                studentsDelta.changePercent > 0
                    ? `naik ${studentsDelta.changePercent}%`
                    : studentsDelta.changePercent < 0
                    ? `turun ${Math.abs(studentsDelta.changePercent)}%`
                    : "stabil (0%)";
            insights.push(
                `Terdapat ${studentsDelta.current} akun pembelajar baru pada periode ${periodLabel} (${trend} dibanding periode sebelumnya).`
            );
        }

        if (actionItems.totalPending > 0) {
            const parts: string[] = [];
            if (actionItems.pendingClasses > 0) parts.push(`${actionItems.pendingClasses} kelas`);
            if (actionItems.pendingWorkshops > 0) parts.push(`${actionItems.pendingWorkshops} workshop`);
            if (actionItems.pendingWorkshopParticipants > 0) {
                parts.push(`${actionItems.pendingWorkshopParticipants} peserta workshop`);
            }
            if (actionItems.pendingQuizGrading > 0) parts.push(`${actionItems.pendingQuizGrading} kuis esai`);
            if (actionItems.pendingAssignmentGrading > 0) {
                parts.push(`${actionItems.pendingAssignmentGrading} tugas`);
            }
            insights.push(`Menunggu tindak lanjut: ${parts.join(", ")}.`);
        }

        if (quizAvg.current > 0) {
            insights.push(`Rata-rata skor evaluasi kuis pada periode ini mencapai ${quizAvg.current} dari 100.`);
        }

        return insights;
    }

    async getDashboardData(params: DashboardQueryParams = {}) {
        const resolved = this.resolveDateRange(params);
        const {
            currentMetrics,
            previousMetrics,
            cumulativeTotals,
            actionItems,
            workshopStats,
            timelineTimestamps,
            legacyCharts,
        } = await dashboardRepository.fetchDashboardAggregations(resolved);

        const makeMetric = (
            current: number,
            previous: number,
            totalCumulative?: number
        ): MetricWithChange => ({
            current,
            previous,
            changePercent: calculateChangePercent(current, previous),
            ...(totalCumulative !== undefined ? { totalCumulative } : {}),
        });

        const studentsMetric = makeMetric(
            currentMetrics.students,
            previousMetrics.students,
            cumulativeTotals.studentsTotal
        );
        const teachersMetric = makeMetric(
            currentMetrics.teachers,
            previousMetrics.teachers,
            cumulativeTotals.teachersTotal
        );
        const classesMetric = makeMetric(
            currentMetrics.classes,
            previousMetrics.classes,
            cumulativeTotals.classesTotal
        );
        const materialsMetric = makeMetric(
            currentMetrics.materials,
            previousMetrics.materials,
            cumulativeTotals.materialsTotal
        );
        const workshopsMetric = makeMetric(
            currentMetrics.workshops,
            previousMetrics.workshops,
            cumulativeTotals.workshopsTotal
        );
        const quizAttemptsMetric = makeMetric(
            currentMetrics.quizAttempts,
            previousMetrics.quizAttempts,
            cumulativeTotals.quizAttemptsTotal
        );
        const assignmentsSubmittedMetric = makeMetric(
            currentMetrics.assignmentsSubmitted,
            previousMetrics.assignmentsSubmitted,
            cumulativeTotals.assignmentsTotal
        );
        const workshopRegistrationsMetric = makeMetric(
            currentMetrics.workshopRegistrations,
            previousMetrics.workshopRegistrations,
            cumulativeTotals.workshopRegistrationsTotal
        );
        const averageQuizScoreMetric = makeMetric(
            currentMetrics.averageQuizScore,
            previousMetrics.averageQuizScore
        );

        const timeline = this.buildTimeline(
            resolved.startDate,
            resolved.endDate,
            resolved.granularity,
            timelineTimestamps
        );

        const periodInfo: PeriodInfo = {
            label: resolved.label,
            granularity: resolved.granularity,
            startDate: resolved.startDate.toISOString(),
            endDate: resolved.endDate.toISOString(),
            previousStartDate: resolved.previousStartDate.toISOString(),
            previousEndDate: resolved.previousEndDate.toISOString(),
        };

        const overview = {
            students: studentsMetric,
            teachers: teachersMetric,
            classes: classesMetric,
            materials: materialsMetric,
            workshops: workshopsMetric,
            quizAttempts: quizAttemptsMetric,
            assignmentsSubmitted: assignmentsSubmittedMetric,
            workshopRegistrations: workshopRegistrationsMetric,
            averageQuizScore: averageQuizScoreMetric,
            totalUsers: {
                students: cumulativeTotals.studentsTotal,
                teachers: cumulativeTotals.teachersTotal,
                admins: cumulativeTotals.adminsTotal,
                total: cumulativeTotals.allUsersTotal,
            },
        };

        const insights = this.buildInsights(
            resolved.label,
            studentsMetric,
            averageQuizScoreMetric,
            actionItems
        );

        return {
            // Backward-compatible top-level fields
            teacherCount: cumulativeTotals.teachersTotal,
            studentCount: cumulativeTotals.studentsTotal,
            classCount: cumulativeTotals.classesTotal,
            Chart: legacyCharts,

            // Rich Analytics Data
            periodInfo,
            actionItems,
            overview,
            timeline,
            workshopStats,
            insights,
        };
    }
}

export default new DashboardService();
