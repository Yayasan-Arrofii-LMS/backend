export type EnrollClassInput = {
    classId: number;
};

export type UnenrollClassInput = {
    classId: number;
};

export type UpdateApplicantStatusInput = {
    status: "APPROVED" | "REJECTED";
};
