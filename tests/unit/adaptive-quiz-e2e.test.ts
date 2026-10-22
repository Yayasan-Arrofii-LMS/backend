import supertest from 'supertest';
import jwt from 'jsonwebtoken';
import app from '../../src';
import prisma from '../../src/database';

const JWT_SECRET = process.env.JWT_SECRET ?? '';

function signTestJwt(userId: string, email: string): string {
    return jwt.sign({ user_id: userId, email }, JWT_SECRET, { expiresIn: '1h' });
}

describe('Fase 3, 4, 5 & 6: End-to-End Adaptive Quiz & Remedial Recommendation Flow', () => {
    let teacherToken: string;
    let studentToken: string;
    let teacherId: string;
    let studentId: string;
    let classId: number;
    let sectionId: number;

    beforeAll(async () => {
        // Ensure roles exist
        const roles = ['Admin', 'Teacher', 'Student'];
        for (const roleName of roles) {
            await prisma.role.upsert({
                where: { name: roleName },
                update: {},
                create: { name: roleName },
            });
        }

        const teacherRole = await prisma.role.findUnique({ where: { name: 'Teacher' } });
        const studentRole = await prisma.role.findUnique({ where: { name: 'Student' } });

        const uniqueSuffix = Date.now();

        const teacher = await prisma.user.create({
            data: {
                name: 'Guru Adaptif',
                email: `guru.adaptif.${uniqueSuffix}@example.com`,
                username: `guru_adaptif_${uniqueSuffix}`,
                password: 'hashedpassword',
                profileImage: 'default.png',
                roleId: teacherRole!.id,
            },
        });
        teacherId = teacher.id;
        teacherToken = signTestJwt(teacher.id, teacher.email);

        const student = await prisma.user.create({
            data: {
                name: 'Siswa Adaptif',
                email: `siswa.adaptif.${uniqueSuffix}@example.com`,
                username: `siswa_adaptif_${uniqueSuffix}`,
                password: 'hashedpassword',
                profileImage: 'default.png',
                roleId: studentRole!.id,
            },
        });
        studentId = student.id;
        studentToken = signTestJwt(student.id, student.email);

        const createdClass = await prisma.class.create({
            data: {
                name: 'Kelas Sains Alam',
                description: 'Kelas pengujian kuis adaptif',
                image_path: 'banner.png',
            },
        });
        classId = createdClass.id;

        await prisma.user_Class.createMany({
            data: [
                { userId: teacherId, classId, role: 'Teacher' },
                { userId: studentId, classId, role: 'Student' },
            ],
        });

        const createdSection = await prisma.section.create({
            data: {
                title: 'Bab 1: Ekosistem & Fotosintesis',
                description: 'Materi ekosistem dan fotosintesis',
                order: 1,
                classId,
            },
        });
        sectionId = createdSection.id;

        // Buat materi dengan tingkat kesulitan berbeda untuk uji rekomendasi remedial (Fase 5)
        await prisma.material.createMany({
            data: [
                {
                    title: 'Materi Lanjutan Ekosistem (Sulit)',
                    content: 'Isi materi sulit',
                    sectionId,
                    order: 1,
                    difficulty: 'Hard',
                    mediaType: 'Text',
                },
                {
                    title: 'Materi Dasar Ekosistem (Mudah)',
                    content: 'Isi materi mudah untuk remedial',
                    sectionId,
                    order: 2,
                    difficulty: 'Easy',
                    mediaType: 'Text',
                },
            ],
        });
    });

    afterAll(async () => {
        if (classId) {
            await prisma.class.delete({ where: { id: classId } }).catch(() => {});
        }
        if (teacherId) {
            await prisma.user.delete({ where: { id: teacherId } }).catch(() => {});
        }
        if (studentId) {
            await prisma.user.delete({ where: { id: studentId } }).catch(() => {});
        }
    });

    it('rejects Essay questions in teacher bulk-create endpoint with 400', async () => {
        const res = await supertest(app)
            .post(`/api/v1/classes/sections/${sectionId}/quizzes/bulk-create`)
            .set('Authorization', `Bearer ${teacherToken}`)
            .send({
                title: 'Kuis Invalid Essay',
                description: 'Kuis dengan soal essay',
                max_attempts: 2,
                time_limit: 30,
                open_at: new Date(Date.now() - 60000).toISOString(),
                close_at: new Date(Date.now() + 3600000).toISOString(),
                passing_grade: 75,
                xp: 100,
                questions: [
                    {
                        question: 'Jelaskan fotosintesis!',
                        type: 'Essay',
                    },
                ],
            });

        expect(res.status).toBe(400);
        expect(res.body.success).toBe(false);
    });

    it('runs full adaptive quiz lifecycle: bulk-create -> start -> resume -> answer 1-by-1 -> anti-double-click -> result -> review -> remedial recommendation', async () => {
        // 1. Guru membuat kuis dengan 4 soal lintas 3 tingkat kesulitan (Easy, Medium, Hard)
        const createRes = await supertest(app)
            .post(`/api/v1/classes/sections/${sectionId}/quizzes/bulk-create`)
            .set('Authorization', `Bearer ${teacherToken}`)
            .send({
                title: 'Kuis Ekosistem Alam',
                description: 'Uji pemahaman ekosistem',
                max_attempts: 3,
                time_limit: 30,
                open_at: new Date(Date.now() - 60000).toISOString(),
                close_at: new Date(Date.now() + 3600000).toISOString(),
                passing_grade: 75,
                xp: 100,
                show_review: true,
                questions: [
                    {
                        question: 'Apa pigmen hijau pada daun?',
                        type: 'MultipleChoice',
                        difficulty: 'Easy',
                        explanation: 'Klorofil memberi warna hijau dan menyerap cahaya.',
                        answers: [
                            { answer: 'Klorofil', is_correct: true },
                            { answer: 'Karoten', is_correct: false },
                        ],
                    },
                    {
                        question: 'Tumbuhan hijau menghasilkan oksigen saat fotosintesis.',
                        type: 'TrueFalse',
                        difficulty: 'Easy',
                        explanation: 'Fotosintesis menghasilkan glukosa dan oksigen.',
                        answers: [
                            { answer: 'Benar', is_correct: true },
                            { answer: 'Salah', is_correct: false },
                        ],
                    },
                    {
                        question: 'Di bagian kloroplas manakah reaksi terang terjadi?',
                        type: 'MultipleChoice',
                        difficulty: 'Medium',
                        explanation: 'Reaksi terang berlangsung di membran tilakoid.',
                        answers: [
                            { answer: 'Tilakoid', is_correct: true },
                            { answer: 'Stroma', is_correct: false },
                        ],
                    },
                    {
                        question: 'Siklus Calvin terjadi di bagian stroma kloroplas.',
                        type: 'TrueFalse',
                        difficulty: 'Hard',
                        explanation: 'Reaksi gelap (Siklus Calvin) terjadi di stroma.',
                        answers: [
                            { answer: 'Benar', is_correct: true },
                            { answer: 'Salah', is_correct: false },
                        ],
                    },
                ],
            });

        expect(createRes.status).toBe(201);
        expect(createRes.body.success).toBe(true);
        expect(createRes.body.data).toBeTruthy();
        expect(createRes.body.data.warnings).toEqual([]);

        const quizId: number = createRes.body.data.id;
        const createdQuestions: any[] = createRes.body.data.quiz_question;
        expect(createdQuestions.length).toBe(4);

        // Simpan peta kunci jawaban benar & salah untuk simulasi siswa
        const correctOptionByQuestionId = new Map<number, number>();
        const wrongOptionByQuestionId = new Map<number, number>();
        for (const q of createdQuestions) {
            const correctOpt = q.quiz_answer.find((a: any) => a.is_correct);
            const wrongOpt = q.quiz_answer.find((a: any) => !a.is_correct);
            correctOptionByQuestionId.set(q.id, correctOpt.id);
            wrongOptionByQuestionId.set(q.id, wrongOpt.id);
        }

        // 2. Guard anti-bocor: Siswa tidak boleh mengambil seluruh daftar soal kuis (ditolak oleh verifyRole)
        const leakAttempt = await supertest(app)
            .get(`/api/v1/quiz/${quizId}/questions`)
            .set('Authorization', `Bearer ${studentToken}`);
        expect([403, 404]).toContain(leakAttempt.status);

        // 3. Siswa memulai kuis (`POST /api/v1/quiz/:quizId/start`) -> hanya menerima 1 soal pertama
        const startRes = await supertest(app)
            .post(`/api/v1/quiz/${quizId}/start`)
            .set('Authorization', `Bearer ${studentToken}`);

        expect(startRes.status).toBe(200);
        expect(startRes.body.success).toBe(true);
        const startData = startRes.body.data;
        expect(startData.attemptId).toEqual(expect.any(Number));
        expect(startData.totalQuestions).toBe(4);
        expect(startData.currentQuestionNumber).toBe(1);
        expect(startData.question).toBeTruthy();
        expect(startData.question.answers.length).toBeGreaterThan(0);
        // Pastikan kunci jawaban `is_correct` TIDAK dikirim ke client
        expect(startData.question.answers[0].is_correct).toBeUndefined();

        const attemptId: number = startData.attemptId;
        const firstQuestionId: number = startData.question.id;

        // 4. Siswa me-refresh halaman (`GET /api/v1/quiz/attempts/:attemptId/current`) -> soal aktif tetap sama
        const resumeRes = await supertest(app)
            .get(`/api/v1/quiz/attempts/${attemptId}/current`)
            .set('Authorization', `Bearer ${studentToken}`);

        expect(resumeRes.status).toBe(200);
        expect(resumeRes.body.data.currentQuestionNumber).toBe(1);
        expect(resumeRes.body.data.question.id).toBe(firstQuestionId);
        expect(resumeRes.body.data.timeRemainingSeconds).toBeGreaterThan(0);

        // 5. Guard anti-bocor pada `/attempts/:attemptId/questions`: hanya 1 soal yang sudah disajikan yang tampak
        const servedQuestionsRes = await supertest(app)
            .get(`/api/v1/quiz/attempts/${attemptId}/questions`)
            .set('Authorization', `Bearer ${studentToken}`);
        expect(servedQuestionsRes.status).toBe(200);
        expect(servedQuestionsRes.body.data.questions.length).toBe(1);
        expect(servedQuestionsRes.body.data.questions[0].id).toBe(firstQuestionId);

        // 6. Siswa menjawab soal ke-1 dengan BENAR (`POST /api/v1/quiz/adaptive/answer`)
        const ans1Res = await supertest(app)
            .post('/api/v1/quiz/adaptive/answer')
            .set('Authorization', `Bearer ${studentToken}`)
            .send({
                attemptId,
                questionId: firstQuestionId,
                selectedAnswerIds: [correctOptionByQuestionId.get(firstQuestionId)!],
            });

        expect(ans1Res.status).toBe(200);
        expect(ans1Res.body.data.done).toBe(false);
        expect(ans1Res.body.data.currentQuestionNumber).toBe(2);
        expect(ans1Res.body.data.nextQuestion).toBeTruthy();
        expect(ans1Res.body.data.nextQuestion.id).not.toBe(firstQuestionId);

        // 7. Proteksi double-click: mengirim ulang jawaban untuk soal ke-1 harus ditolak (400)
        const duplicateAns1Res = await supertest(app)
            .post('/api/v1/quiz/adaptive/answer')
            .set('Authorization', `Bearer ${studentToken}`)
            .send({
                attemptId,
                questionId: firstQuestionId,
                selectedAnswerIds: [correctOptionByQuestionId.get(firstQuestionId)!],
            });
        expect(duplicateAns1Res.status).toBe(400);
        expect(duplicateAns1Res.body.message).toContain('sudah dijawab');

        // 8. Siswa menjawab soal ke-2 BENAR, soal ke-3 BENAR, soal ke-4 SALAH -> 3/4 = 75% (Lulus, Cakap)
        const q2Id = ans1Res.body.data.nextQuestion.id;
        const ans2Res = await supertest(app)
            .post('/api/v1/quiz/adaptive/answer')
            .set('Authorization', `Bearer ${studentToken}`)
            .send({
                attemptId,
                questionId: q2Id,
                selectedAnswerIds: [correctOptionByQuestionId.get(q2Id)!],
            });
        expect(ans2Res.status).toBe(200);
        expect(ans2Res.body.data.done).toBe(false);
        expect(ans2Res.body.data.currentQuestionNumber).toBe(3);

        const q3Id = ans2Res.body.data.nextQuestion.id;
        const ans3Res = await supertest(app)
            .post('/api/v1/quiz/adaptive/answer')
            .set('Authorization', `Bearer ${studentToken}`)
            .send({
                attemptId,
                questionId: q3Id,
                selectedAnswerIds: [correctOptionByQuestionId.get(q3Id)!],
            });
        expect(ans3Res.status).toBe(200);
        expect(ans3Res.body.data.done).toBe(false);
        expect(ans3Res.body.data.currentQuestionNumber).toBe(4);

        const q4Id = ans3Res.body.data.nextQuestion.id;
        const ans4Res = await supertest(app)
            .post('/api/v1/quiz/adaptive/answer')
            .set('Authorization', `Bearer ${studentToken}`)
            .send({
                attemptId,
                questionId: q4Id,
                selectedAnswerIds: [wrongOptionByQuestionId.get(q4Id)!],
            });
        expect(ans4Res.status).toBe(200);
        expect(ans4Res.body.data.done).toBe(true);
        expect(ans4Res.body.data.attemptId).toBe(attemptId);

        // 9. Cek halaman Result (`GET /api/v1/quiz/attempts/:attemptId/result`)
        const resultRes = await supertest(app)
            .get(`/api/v1/quiz/attempts/${attemptId}/result`)
            .set('Authorization', `Bearer ${studentToken}`);

        expect(resultRes.status).toBe(200);
        expect(resultRes.body.data).toMatchObject({
            attemptId,
            quizTitle: 'Kuis Ekosistem Alam',
            score: 75,
            passingGrade: 75,
            isPassed: true,
            totalQuestions: 4,
            correctAnswersCount: 3,
            abilityLevel: 'Cakap',
            showReview: true,
        });
        expect(typeof resultRes.body.data.abilityEstimate).toBe('number');

        // 10. Cek halaman Review (`GET /api/v1/quiz/attempts/:attemptId/review`)
        const reviewRes = await supertest(app)
            .get(`/api/v1/quiz/attempts/${attemptId}/review`)
            .set('Authorization', `Bearer ${studentToken}`);

        expect(reviewRes.status).toBe(200);
        expect(reviewRes.body.data.showReview).toBe(true);
        expect(reviewRes.body.data.reviews.length).toBe(4);
        expect(reviewRes.body.data.reviews[0]).toMatchObject({
            order: 1,
            questionId: firstQuestionId,
            isCorrect: true,
            difficulty: expect.stringMatching(/Easy|Medium|Hard/),
        });

        // 11. Uji `show_review = false`: Guru menonaktifkan pembahasan
        await supertest(app)
            .put(`/api/v1/quiz/${quizId}`)
            .set('Authorization', `Bearer ${teacherToken}`)
            .send({ show_review: false })
            .expect(200);

        const studentHiddenReview = await supertest(app)
            .get(`/api/v1/quiz/attempts/${attemptId}/review`)
            .set('Authorization', `Bearer ${studentToken}`);
        expect(studentHiddenReview.status).toBe(200);
        expect(studentHiddenReview.body.data.showReview).toBe(false);
        expect(studentHiddenReview.body.data.reviews).toEqual([]);

        // Namun Guru tetap dapat melihat pembahasan lengkap & kesulitan untuk diagnostik
        const teacherReview = await supertest(app)
            .get(`/api/v1/quiz/attempts/${attemptId}/review`)
            .set('Authorization', `Bearer ${teacherToken}`);
        expect(teacherReview.status).toBe(200);
        expect(teacherReview.body.data.reviews.length).toBe(4);

        // 12. Uji Fase 5 (Integrasi Hasil -> Rekomendasi Remedial):
        // Siswa melakukan percobaan ke-2 dan gagal (skor 25% < passing_grade 75%, level Dasar)
        const startAttempt2 = await supertest(app)
            .post(`/api/v1/quiz/${quizId}/start`)
            .set('Authorization', `Bearer ${studentToken}`)
            .expect(200);

        const attempt2Id = startAttempt2.body.data.attemptId;
        let currentQ = startAttempt2.body.data.question;

        for (let step = 0; step < 4; step++) {
            const selectedOption =
                step === 0
                    ? correctOptionByQuestionId.get(currentQ.id)!
                    : wrongOptionByQuestionId.get(currentQ.id)!;

            const stepRes = await supertest(app)
                .post('/api/v1/quiz/adaptive/answer')
                .set('Authorization', `Bearer ${studentToken}`)
                .send({
                    attemptId: attempt2Id,
                    questionId: currentQ.id,
                    selectedAnswerIds: [selectedOption],
                })
                .expect(200);

            if (!stepRes.body.data.done) {
                currentQ = stepRes.body.data.nextQuestion;
            }
        }

        const attempt2Result = await supertest(app)
            .get(`/api/v1/quiz/attempts/${attempt2Id}/result`)
            .set('Authorization', `Bearer ${studentToken}`)
            .expect(200);

        expect(attempt2Result.body.data.score).toBe(25);
        expect(attempt2Result.body.data.isPassed).toBe(false);
        expect(attempt2Result.body.data.abilityLevel).toBe('Dasar');

        // Panggil endpoint rekomendasi: materi di section ini harus berstatus 'remedial' dan mengutamakan materi 'Easy'
        const recRes = await supertest(app)
            .get('/api/v1/recommendations')
            .set('Authorization', `Bearer ${studentToken}`)
            .expect(200);

        expect(recRes.body.success).toBe(true);
        const sectionRecs = recRes.body.data.filter(
            (item: any) => item.material.sectionId === sectionId
        );
        expect(sectionRecs.length).toBe(2);
        expect(sectionRecs[0].reasons).toContain('remedial');
        expect(sectionRecs[0].material.difficulty).toBe('Easy');
    });
});
