import "dotenv/config";
import request from "supertest";
import jwt from "jsonwebtoken";
import app from "../../src/index";
import prisma from "../../src/database";

describe("Quiz Essay & Teacher Manual Grading E2E", () => {
    let teacherToken: string;
    let studentToken: string;
    let classId: number;
    let sectionId: number;
    let quizId: number;

    beforeAll(async () => {
        for (const name of ["Admin", "Teacher", "Student"]) {
            await prisma.role.upsert({ where: { name }, update: {}, create: { name } });
        }
        const teacherRole = await prisma.role.findUnique({ where: { name: "Teacher" } });
        const studentRole = await prisma.role.findUnique({ where: { name: "Student" } });

        const teacher = await prisma.user.upsert({
            where: { email: "essay_teacher_test@sekolahalam.id" },
            update: { roleId: teacherRole!.id },
            create: {
                email: "essay_teacher_test@sekolahalam.id",
                username: "essay_teacher_test",
                name: "Guru Essay",
                password: "hashedpassword",
                profileImage: "https://ui-avatars.com/api/?name=Guru+Essay",
                roleId: teacherRole!.id,
                verified_at: new Date(),
            },
        });

        const student = await prisma.user.upsert({
            where: { email: "essay_student_test@sekolahalam.id" },
            update: { roleId: studentRole!.id },
            create: {
                email: "essay_student_test@sekolahalam.id",
                username: "essay_student_test",
                name: "Siswa Essay",
                password: "hashedpassword",
                profileImage: "https://ui-avatars.com/api/?name=Siswa+Essay",
                roleId: studentRole!.id,
                verified_at: new Date(),
            },
        });

        const cls = await prisma.class.create({
            data: {
                name: "Kelas Uji Essay Kuis",
                description: "Kelas untuk verifikasi soal essay",
                image_path: "files/public/placeholder.png",
                approvalStatus: "APPROVED",
                registrationType: "AUTO",
            },
        });
        classId = cls.id;

        const sec = await prisma.section.create({
            data: {
                title: "Bab Essay",
                order: 1,
                classId: cls.id,
            },
        });
        sectionId = sec.id;

        const secret = process.env.JWT_SECRET ?? "";
        teacherToken = jwt.sign({ user_id: teacher.id }, secret, { expiresIn: "1h" });
        studentToken = jwt.sign({ user_id: student.id }, secret, { expiresIn: "1h" });
    });

    afterAll(async () => {
        if (classId) {
            await prisma.class.deleteMany({ where: { id: classId } });
        }
        await prisma.$disconnect();
    });

    it("supports creating MCQ + Essay quiz, student submission, teacher grading, and student review", async () => {
        // 1. Bulk create quiz with 1 MCQ (10 pts) + 1 Essay (10 pts, with instructions & rubric)
        const createRes = await request(app)
            .post(`/api/v1/classes/sections/${sectionId}/quizzes/bulk-create`)
            .set("Authorization", `Bearer ${teacherToken}`)
            .send({
                title: "Kuis Campuran PG & Uraian",
                description: "Menguji pemahaman konseptual dan uraian",
                max_attempts: 2,
                time_limit: 30,
                open_at: new Date(Date.now() - 60000).toISOString(),
                close_at: new Date(Date.now() + 3600000).toISOString(),
                passing_grade: 70,
                xp: 50,
                show_review: true,
                questions: [
                    {
                        question: "Gas apakah yang diserap tumbuhan saat fotosintesis?",
                        type: "MultipleChoice",
                        points: 10,
                        difficulty: "Easy",
                        answers: [
                            { answer: "Karbon dioksida", is_correct: true },
                            { answer: "Nitrogen", is_correct: false },
                        ],
                    },
                    {
                        question: "Jelaskan peran kompos organik bagi kesuburan tanah!",
                        type: "Essay",
                        points: 10,
                        difficulty: "Medium",
                        instructions: "Jawab minimal dalam 2 kalimat.",
                        rubric: "5 poin untuk struktur tanah, 5 poin untuk mikroorganisme.",
                    },
                ],
            });

        expect(createRes.status).toBe(201);
        quizId = createRes.body.data.id;
        const questions: any[] = createRes.body.data.quiz_question;
        expect(questions.length).toBe(2);

        const mcqQ = questions.find((q) => q.type === "MultipleChoice");
        const essayQ = questions.find((q) => q.type === "Essay");
        expect(essayQ.instructions).toBe("Jawab minimal dalam 2 kalimat.");
        expect(essayQ.rubric).toBe("5 poin untuk struktur tanah, 5 poin untuk mikroorganisme.");

        const correctMcqOption = mcqQ.quiz_answer.find((a: any) => a.is_correct);

        // 2. Student starts quiz -> both id and attemptId present
        const startRes = await request(app)
            .post(`/api/v1/classes/sections/${sectionId}/quizzes/${quizId}/start`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(startRes.status).toBe(200);
        expect(startRes.body.data.id).toBe(startRes.body.data.attemptId);
        const attemptId = startRes.body.data.id;

        // 3. Student fetches attempt questions -> gets both MCQ & Essay with instructions, no rubric
        const qListRes = await request(app)
            .get(`/api/v1/classes/sections/${sectionId}/quizzes/attempts/${attemptId}/questions`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(qListRes.status).toBe(200);
        expect(qListRes.body.data.questions.length).toBe(2);
        const studentEssayQ = qListRes.body.data.questions.find((q: any) => q.type === "Essay");
        expect(studentEssayQ.instructions).toBe("Jawab minimal dalam 2 kalimat.");
        expect(studentEssayQ.rubric).toBeUndefined();

        // 4. Student saves MCQ & Essay answers
        const saveMcq = await request(app)
            .post(`/api/v1/classes/sections/${sectionId}/quizzes/save-answer`)
            .set("Authorization", `Bearer ${studentToken}`)
            .send({
                attemptId,
                questionId: mcqQ.id,
                selectedAnswerIds: [correctMcqOption.id],
            });
        expect(saveMcq.status).toBe(200);

        const saveEssay = await request(app)
            .post(`/api/v1/classes/sections/${sectionId}/quizzes/save-answer`)
            .set("Authorization", `Bearer ${studentToken}`)
            .send({
                attemptId,
                questionId: essayQ.id,
                answer: "Kompos organik memperbaiki struktur tanah dan meningkatkan aktivitas mikroorganisme baik.",
            });
        expect(saveEssay.status).toBe(200);

        // 5. Student submits quiz -> WAITING_FOR_TEACHER, is_graded: false, mcqScore: 10
        const submitRes = await request(app)
            .post(`/api/v1/classes/sections/${sectionId}/quizzes/submit`)
            .set("Authorization", `Bearer ${studentToken}`)
            .send({ attemptId });
        expect(submitRes.status).toBe(200);
        expect(submitRes.body.data.is_graded).toBe(false);
        expect(submitRes.body.data.grading_status).toBe("WAITING_FOR_TEACHER");
        expect(submitRes.body.data.gradingStatus).toBe("Menunggu Penilaian");
        expect(submitRes.body.data.mcqScore).toBe(10);
        expect(submitRes.body.data.score).toBeNull();

        // 6. Teacher fetches submissions -> includes user object AND flat studentName/studentEmail/studentAvatar
        const subsRes = await request(app)
            .get(`/api/v1/classes/sections/${sectionId}/quizzes/${quizId}/submissions`)
            .set("Authorization", `Bearer ${teacherToken}`);
        expect(subsRes.status).toBe(200);
        expect(subsRes.body.data.length).toBe(1);
        expect(subsRes.body.data[0]).toMatchObject({
            attemptId,
            studentName: "Siswa Essay",
            studentEmail: "essay_student_test@sekolahalam.id",
            essayCount: 1,
            ungradedEssayCount: 1,
            isGraded: false,
            mcqScore: 10,
            gradingStatus: "Menunggu Penilaian",
        });
        expect(subsRes.body.data[0].user).toMatchObject({
            name: "Siswa Essay",
            email: "essay_student_test@sekolahalam.id",
        });

        // 7. Teacher fetches attempt grading detail -> includes rubric & student answer
        const detailRes = await request(app)
            .get(`/api/v1/classes/sections/${sectionId}/quizzes/attempts/${attemptId}/grading`)
            .set("Authorization", `Bearer ${teacherToken}`);
        expect(detailRes.status).toBe(200);
        expect(detailRes.body.data.studentName).toBe("Siswa Essay");
        expect(detailRes.body.data.user.name).toBe("Siswa Essay");
        expect(detailRes.body.data.totalMaxPoints).toBe(20);
        const gradingEssay = detailRes.body.data.questions.find((q: any) => q.type === "Essay");
        expect(gradingEssay.rubric).toBe("5 poin untuk struktur tanah, 5 poin untuk mikroorganisme.");
        expect(gradingEssay.studentAnswer).toContain("mikroorganisme baik");

        // 8. Reject score exceeding question max points
        const invalidGrade = await request(app)
            .post(`/api/v1/classes/sections/${sectionId}/quizzes/attempts/${attemptId}/grade`)
            .set("Authorization", `Bearer ${teacherToken}`)
            .send({
                grades: [{ questionId: essayQ.id, score: 15, feedback: "Terlalu tinggi" }],
            });
        expect(invalidGrade.status).toBe(400);

        // 9. Teacher submits valid essay grade (8 / 10) -> total 18 / 20 = 90%
        const gradeRes = await request(app)
            .post(`/api/v1/classes/sections/${sectionId}/quizzes/attempts/${attemptId}/grade`)
            .set("Authorization", `Bearer ${teacherToken}`)
            .send({
                grades: [
                    {
                        questionId: essayQ.id,
                        score: 8,
                        feedback: "Penjelasan sangat baik dan runtut!",
                    },
                ],
            });
        expect(gradeRes.status).toBe(200);
        expect(gradeRes.body.data.isGraded).toBe(true);
        expect(gradeRes.body.data.gradingStatus).toBe("Penilaian Selesai");
        expect(gradeRes.body.data.totalEarnedPoints).toBe(18);
        expect(gradeRes.body.data.totalMaxPoints).toBe(20);
        expect(gradeRes.body.data.finalScore).toBe(90);

        // 10. Student checks result & review -> sees 90%, Passed, essay score & feedback
        const resultRes = await request(app)
            .get(`/api/v1/classes/sections/${sectionId}/quizzes/attempts/${attemptId}/result`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(resultRes.status).toBe(200);
        expect(resultRes.body.data.isGraded).toBe(true);
        expect(resultRes.body.data.finalScore).toBe(90);
        expect(resultRes.body.data.isPassed).toBe(true);

        const reviewRes = await request(app)
            .get(`/api/v1/classes/sections/${sectionId}/quizzes/attempts/${attemptId}/review`)
            .set("Authorization", `Bearer ${studentToken}`);
        expect(reviewRes.status).toBe(200);
        const reviewedEssay = reviewRes.body.data.questions.find((q: any) => q.type === "Essay");
        expect(reviewedEssay.studentScore).toBe(8);
        expect(reviewedEssay.feedback).toBe("Penjelasan sangat baik dan runtut!");
        expect(reviewedEssay.studentAnswerText).toContain("mikroorganisme baik");
    });
});
