import supertest from 'supertest';
import jwt from 'jsonwebtoken';
import app from '../../src';
import prisma from '../../src/database';
import {
    estimateMaterialDuration,
    extractMaterialExcerpt,
    resolveMaterialThumbnail,
    stripHtmlTags,
} from '../../src/api/v1/helpers/materialContent.helper';

const JWT_SECRET = process.env.JWT_SECRET ?? '';

function signTestJwt(userId: string, email: string): string {
    return jwt.sign({ user_id: userId, email }, JWT_SECRET, { expiresIn: '1h' });
}

describe('Recommendation Engine Enhancement & Phase 6 Personalization Tests', () => {
    describe('Unit: materialContent.helper (Excerpt, Write-Time Duration, Thumbnail)', () => {
        it('strips HTML tags and truncates excerpt cleanly at word boundary', () => {
            const html =
                '<p>Hutan <strong>hujan tropis</strong> memiliki&nbsp;empat lapisan utama yang menjadi habitat penting bagi flora dan fauna endemik nusantara di sekitar sekolah alam kita.</p>';
            const stripped = stripHtmlTags(html);
            expect(stripped).not.toContain('<p>');
            expect(stripped).toContain('Hutan hujan tropis memiliki empat');

            const excerpt = extractMaterialExcerpt(html, 70);
            expect(excerpt.length).toBeLessThanOrEqual(73);
            expect(excerpt.endsWith('...')).toBe(true);
        });

        it('estimates study duration lightly for text, video, and practical modules', () => {
            expect(
                estimateMaterialDuration({ content: '<p>Artikel pendek</p>', mediaType: 'Text' })
            ).toBe(5);

            const longText = new Array(540).fill('ekosistem').join(' '); // ~3 mins -> min 5, let's test 1100 words (~7 mins)
            const veryLongText = new Array(1100).fill('ekosistem').join(' ');
            expect(
                estimateMaterialDuration({ content: veryLongText, mediaType: 'Artikel' })
            ).toBe(7);

            expect(
                estimateMaterialDuration({
                    content: '<p>Catatan video singkat</p>',
                    mediaType: 'Video',
                })
            ).toBe(12);

            expect(
                estimateMaterialDuration({
                    content: '<p>Modul praktik lapangan</p>',
                    mediaType: 'Modul Praktik',
                })
            ).toBe(10);
        });

        it('resolves thumbnail from HTML <img> or falls back to class image_path', () => {
            const fromHtml = resolveMaterialThumbnail(
                '<p>Intro</p><img src="https://cdn.example.com/forest.jpg" />',
                'uploads/class-cover.png'
            );
            expect(fromHtml).toBe('https://cdn.example.com/forest.jpg');

            const fromClassFallback = resolveMaterialThumbnail(
                '<p>Tanpa gambar</p>',
                'uploads/class-cover.png'
            );
            expect(fromClassFallback).toContain('/uploads/class-cover.png');
        });
    });

    describe('E2E: 4-Reason Engine, Overview Spotlights, Feedback, History & Material Completion', () => {
        let teacherId: string;
        let studentId: string;
        let outsiderId: string;
        let teacherToken: string;
        let studentToken: string;
        let outsiderToken: string;

        let interestCategoryId: number;
        let otherCategoryId: number;
        let classId: number;
        let sec1PassedId: number;
        let sec2NextId: number;
        let sec3RemedialId: number;

        let mat1ADoneId: number;
        let mat1BInProgressId: number;
        let mat2ANextId: number;
        let mat3ARemedialEasyId: number;

        beforeAll(async () => {
            for (const roleName of ['Admin', 'Teacher', 'Student']) {
                await prisma.role.upsert({
                    where: { name: roleName },
                    update: {},
                    create: { name: roleName },
                });
            }

            const teacherRole = await prisma.role.findUnique({ where: { name: 'Teacher' } });
            const studentRole = await prisma.role.findUnique({ where: { name: 'Student' } });
            const suffix = Date.now();

            const [teacher, student, outsider, catInterest, catOther] = await Promise.all([
                prisma.user.create({
                    data: {
                        name: 'Guru Rekomendasi',
                        email: `guru.rec.${suffix}@example.com`,
                        username: `guru_rec_${suffix}`,
                        password: 'hashedpassword',
                        profileImage: 'default.png',
                        roleId: teacherRole!.id,
                    },
                }),
                prisma.user.create({
                    data: {
                        name: 'Siswa Rekomendasi',
                        email: `siswa.rec.${suffix}@example.com`,
                        username: `siswa_rec_${suffix}`,
                        password: 'hashedpassword',
                        profileImage: 'default.png',
                        roleId: studentRole!.id,
                    },
                }),
                prisma.user.create({
                    data: {
                        name: 'Siswa Luar Kelas',
                        email: `outsider.rec.${suffix}@example.com`,
                        username: `outsider_rec_${suffix}`,
                        password: 'hashedpassword',
                        profileImage: 'default.png',
                        roleId: studentRole!.id,
                    },
                }),
                prisma.category.create({
                    data: { name: `Sains Alam Uji ${suffix}` },
                }),
                prisma.category.create({
                    data: { name: `Lingkungan Uji ${suffix}` },
                }),
            ]);

            teacherId = teacher.id;
            studentId = student.id;
            outsiderId = outsider.id;
            teacherToken = signTestJwt(teacher.id, teacher.email);
            studentToken = signTestJwt(student.id, student.email);
            outsiderToken = signTestJwt(outsider.id, outsider.email);

            interestCategoryId = catInterest.id;
            otherCategoryId = catOther.id;

            // Simpan minat siswa ke kategori Sains Alam Uji
            await prisma.userInterest.create({
                data: {
                    userId: studentId,
                    categoryId: interestCategoryId,
                },
            });

            const testClass = await prisma.class.create({
                data: {
                    name: `Kelas Eksplorasi Alam ${suffix}`,
                    description: 'Kelas pengujian fitur personalisasi rekomendasi Phase 6',
                    image_path: 'uploads/eksplorasi-alam.jpg',
                    categoryId: otherCategoryId,
                },
            });
            classId = testClass.id;

            await prisma.user_Class.createMany({
                data: [
                    { userId: teacherId, classId, role: 'Teacher' },
                    { userId: studentId, classId, role: 'Student' },
                ],
            });

            // Buat 3 Section berurutan:
            // Section 1: Prasyarat lulus kuis (90/75), 1 dari 2 materi sudah selesai -> progres 50%
            // Section 2: Belum pernah dibuka/diselesaikan -> Materi Lanjutan + Progression Spotlight
            // Section 3: Gagal kuis (55/75) -> Remedial + Remedial Spotlight
            const sec1 = await prisma.section.create({
                data: {
                    title: 'Dasar Pengamatan Ekosistem Hutan',
                    description: 'Bab 1 prasyarat dasar',
                    order: 1,
                    classId,
                },
            });
            const sec2 = await prisma.section.create({
                data: {
                    title: 'Konservasi & Restorasi Ekosistem Lanjutan',
                    description: 'Bab 2 lanjutan',
                    order: 2,
                    classId,
                },
            });
            const sec3 = await prisma.section.create({
                data: {
                    title: 'Pengelolaan Sampah Sekolah',
                    description: 'Bab 3 evaluasi pengelolaan sampah',
                    order: 3,
                    classId,
                },
            });

            sec1PassedId = sec1.id;
            sec2NextId = sec2.id;
            sec3RemedialId = sec3.id;

            // Uji write-time duration precomputation & manual override lewat endpoint Guru
            const mat1ARes = await supertest(app)
                .post(`/api/v1/classes/sections/${sec1PassedId}/materials`)
                .set('Authorization', `Bearer ${teacherToken}`)
                .send({
                    title: 'Mengenal Stratifikasi Kanopi Hutan',
                    content: '<p>Pengenalan empat lapisan utama kanopi hutan hujan tropis.</p>',
                    xp: 20,
                    categoryId: interestCategoryId,
                    difficulty: 'Easy',
                    mediaType: 'Artikel',
                })
                .expect(201);
            mat1ADoneId = mat1ARes.body.data.id;
            expect(mat1ARes.body.data.duration_minutes).toBe(5); // auto precomputed!

            const mat1BRes = await supertest(app)
                .post(`/api/v1/classes/sections/${sec1PassedId}/materials`)
                .set('Authorization', `Bearer ${teacherToken}`)
                .send({
                    title: 'Interaksi Rantai Makanan Hutan',
                    content: '<p>Video dokumentasi interaksi produsen, konsumen, dan dekomposer hutan.</p>',
                    xp: 30,
                    categoryId: interestCategoryId,
                    difficulty: 'Medium',
                    mediaType: 'Video',
                    video_link: 'https://www.youtube.com/watch?v=kYkyXbH6Bco',
                    duration_minutes: 15, // manual override Guru
                })
                .expect(201);
            mat1BInProgressId = mat1BRes.body.data.id;
            expect(mat1BRes.body.data.duration_minutes).toBe(15);

            const mat2A = await prisma.material.create({
                data: {
                    title: 'Teknik Restorasi Habitat & Pembibitan Pohon',
                    content: '<p>Strategi restorasi habitat hutan dan pemulihan keanekaragaman hayati.</p>',
                    xp: 35,
                    order: 1,
                    sectionId: sec2NextId,
                    categoryId: otherCategoryId,
                    difficulty: 'Medium',
                    mediaType: 'Materi Interaktif',
                    duration_minutes: 25,
                },
            });
            mat2ANextId = mat2A.id;

            const mat3AEasy = await prisma.material.create({
                data: {
                    title: 'Pengelolaan Sampah Organik untuk Pemula',
                    content: '<p>Fokus penguatan identifikasi sampah organik dapur dan metode lubang biopori.</p>',
                    xp: 25,
                    order: 1,
                    sectionId: sec3RemedialId,
                    categoryId: otherCategoryId,
                    difficulty: 'Easy',
                    mediaType: 'Modul Praktik',
                    duration_minutes: 18,
                },
            });
            mat3ARemedialEasyId = mat3AEasy.id;

            // Tandai mat1A sudah selesai & mat1B sudah dibuka oleh siswa
            await prisma.user_Material.create({
                data: {
                    userId: studentId,
                    materialId: mat1ADoneId,
                    is_completed: true,
                },
            });
            await prisma.materialActivity.createMany({
                data: [
                    { userId: studentId, materialId: mat1ADoneId, action: 'opened' },
                    { userId: studentId, materialId: mat1ADoneId, action: 'completed' },
                    { userId: studentId, materialId: mat1BInProgressId, action: 'opened' },
                ],
            });

            // Buat Kuis Lulus di Section 1 (Skor 90 / Passing Grade 75) & Kuis Gagal di Section 3 (Skor 55 / Passing Grade 75)
            const now = new Date();
            const nextWeek = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);

            const quiz1 = await prisma.quiz.create({
                data: {
                    title: 'Identifikasi Flora & Fauna Alam',
                    description: 'Evaluasi bab 1',
                    max_attempts: 3,
                    time_limit: 20,
                    open_at: now,
                    close_at: nextWeek,
                    passing_grade: 75,
                    xp: 50,
                    sectionId: sec1PassedId,
                },
            });

            await prisma.quiz_Attempt.create({
                data: {
                    userId: studentId,
                    quizId: quiz1.id,
                    score: 90,
                    ability_estimate: 1.2,
                    is_graded: true,
                    submitted_at: now,
                },
            });

            const quiz3 = await prisma.quiz.create({
                data: {
                    title: 'Evaluasi Pengelolaan Sampah',
                    description: 'Evaluasi bab 3',
                    max_attempts: 3,
                    time_limit: 20,
                    open_at: now,
                    close_at: nextWeek,
                    passing_grade: 75,
                    xp: 50,
                    sectionId: sec3RemedialId,
                },
            });

            await prisma.quiz_Attempt.create({
                data: {
                    userId: studentId,
                    quizId: quiz3.id,
                    score: 55,
                    ability_estimate: -0.6,
                    is_graded: true,
                    submitted_at: now,
                },
            });
        });

        afterAll(async () => {
            // Bersihkan seluruh entitas uji secara terisolasi tanpa mengganggu data demo
            if (classId) {
                await prisma.class.delete({ where: { id: classId } }).catch(() => {});
            }
            for (const uid of [teacherId, studentId, outsiderId]) {
                if (uid) {
                    await prisma.user.delete({ where: { id: uid } }).catch(() => {});
                }
            }
            for (const cid of [interestCategoryId, otherCategoryId]) {
                if (cid) {
                    await prisma.category.delete({ where: { id: cid } }).catch(() => {});
                }
            }
        });

        it('returns enriched 4-reason recommendations and supports ?type= filtering', async () => {
            const allRes = await supertest(app)
                .get('/api/v1/recommendations')
                .set('Authorization', `Bearer ${studentToken}`)
                .expect(200);

            expect(allRes.body.success).toBe(true);
            const items: any[] = allRes.body.data;
            expect(items.length).toBe(3); // mat1A sudah selesai sehingga tidak masuk list aktif

            // Urutan prioritas: mat3A (remedial +4, lanjutan +1 = 5) & mat1B (minat +3, progres +2 = 5 -> remedial menang tie-breaker!)
            expect(items[0].material.id).toBe(mat3ARemedialEasyId);
            expect(items[0].primaryReason).toBe('remedial');
            expect(items[0].estimatedMinutes).toBe(18);
            expect(items[0].evaluationContext).toMatchObject({
                currentScore: 55,
                passingGrade: 75,
                isPassed: false,
            });
            expect(items[0].excerpt).not.toContain('<p>');
            expect(items[0].thumbnailUrl).toContain('/uploads/eksplorasi-alam.jpg');

            const mat1BItem = items.find((i) => i.material.id === mat1BInProgressId);
            expect(mat1BItem).toBeTruthy();
            expect(mat1BItem.reasons).toEqual(expect.arrayContaining(['minat', 'progres']));
            expect(mat1BItem.progressPercent).toBe(50); // 1 dari 2 materi di Section 1 selesai = 50%
            expect(mat1BItem.learningStatus).toBe('in_progress');

            // Filter ?type=progres menyesuaikan primaryReason & reasonText ke konteks progres
            const progresRes = await supertest(app)
                .get('/api/v1/recommendations?type=progres')
                .set('Authorization', `Bearer ${studentToken}`)
                .expect(200);
            expect(progresRes.body.data.length).toBe(1);
            expect(progresRes.body.data[0].material.id).toBe(mat1BInProgressId);
            expect(progresRes.body.data[0].primaryReason).toBe('progres');
            expect(progresRes.body.data[0].reasonText).toContain('progres belajarmu');

            // Filter ?type=lanjutan
            const lanjutanRes = await supertest(app)
                .get('/api/v1/recommendations?type=lanjutan')
                .set('Authorization', `Bearer ${studentToken}`)
                .expect(200);
            expect(
                lanjutanRes.body.data.some((i: any) => i.material.id === mat2ANextId)
            ).toBe(true);

            // Invalid type ditolak 400
            await supertest(app)
                .get('/api/v1/recommendations?type=ngawur')
                .set('Authorization', `Bearer ${studentToken}`)
                .expect(400);
        });

        it('returns overview stats, remedialSpotlight (55/75), and progressionSpotlight (90/100)', async () => {
            const ovRes = await supertest(app)
                .get('/api/v1/recommendations/overview')
                .set('Authorization', `Bearer ${studentToken}`)
                .expect(200);

            expect(ovRes.body.success).toBe(true);
            const { stats, remedialSpotlight, progressionSpotlight } = ovRes.body.data;

            expect(stats).toMatchObject({
                totalRecommended: 3,
                totalOpened: 1, // mat1B sudah dibuka
                totalCompleted: 0,
                completionRate: 0,
                totalFeedback: 0,
                isAdaptiveActive: true,
            });

            // Banner "Perkuat Pemahamanmu"
            expect(remedialSpotlight).toBeTruthy();
            expect(remedialSpotlight).toMatchObject({
                targetCompetency: 'Pengelolaan Sampah Sekolah',
                currentScore: 55,
                passingGrade: 75,
                material: {
                    id: mat3ARemedialEasyId,
                    title: 'Pengelolaan Sampah Organik untuk Pemula',
                    estimatedMinutes: 18,
                },
            });

            // Banner "Lanjutkan Perjalanan Belajarmu"
            // Karena Section 1 sudah LULUS kuis (90 >= 75), spotlight membuka materi yang belum tuntas
            expect(progressionSpotlight).toBeTruthy();
            expect(progressionSpotlight.prerequisite).toMatchObject({
                materialId: mat1ADoneId,
                materialTitle: 'Mengenal Stratifikasi Kanopi Hutan',
                competencyTitle: 'Identifikasi Flora & Fauna Alam',
                score: 90,
                isQuizPassed: true,
            });
            expect(progressionSpotlight.nextMaterial.id).toBe(mat2ANextId);
        });

        it('saves, toggles, and guards recommendation feedback', async () => {
            // Simpan feedback 'relevant' (👍)
            const fbRes = await supertest(app)
                .post(`/api/v1/recommendations/${mat1BInProgressId}/feedback`)
                .set('Authorization', `Bearer ${studentToken}`)
                .send({ feedback: 'relevant' })
                .expect(200);

            expect(fbRes.body.data).toMatchObject({
                materialId: mat1BInProgressId,
                feedback: 'relevant',
            });

            // Cek totalFeedback naik jadi 1 di overview
            const ovAfter = await supertest(app)
                .get('/api/v1/recommendations/overview')
                .set('Authorization', `Bearer ${studentToken}`)
                .expect(200);
            expect(ovAfter.body.data.stats.totalFeedback).toBe(1);

            // Toggle un-select (null) -> kembali 0, lalu pilih 'relevant' lagi
            await supertest(app)
                .post(`/api/v1/recommendations/${mat1BInProgressId}/feedback`)
                .set('Authorization', `Bearer ${studentToken}`)
                .send({ feedback: null })
                .expect(200);

            const ovCleared = await supertest(app)
                .get('/api/v1/recommendations/overview')
                .set('Authorization', `Bearer ${studentToken}`)
                .expect(200);
            expect(ovCleared.body.data.stats.totalFeedback).toBe(0);

            await supertest(app)
                .post(`/api/v1/recommendations/${mat1BInProgressId}/feedback`)
                .set('Authorization', `Bearer ${studentToken}`)
                .send({ feedback: 'relevant' })
                .expect(200);

            // Siswa luar kelas yang tidak terdaftar harus ditolak 403
            await supertest(app)
                .post(`/api/v1/recommendations/${mat1BInProgressId}/feedback`)
                .set('Authorization', `Bearer ${outsiderToken}`)
                .send({ feedback: 'relevant' })
                .expect(403);
        });

        it('completes material idempotently and preserves completed record in Riwayat Rekomendasi', async () => {
            // Siswa menuntaskan mat1B lewat POST /api/v1/materials/:materialId/complete
            const comp1 = await supertest(app)
                .post(`/api/v1/materials/${mat1BInProgressId}/complete`)
                .set('Authorization', `Bearer ${studentToken}`)
                .expect(200);

            expect(comp1.body.data).toMatchObject({
                materialId: mat1BInProgressId,
                sectionId: sec1PassedId,
                isCompleted: true,
                xpEarned: 30,
                sectionProgressPercent: 100, // 2 dari 2 materi di Section 1 selesai = 100%!
            });

            // Pemanggilan ke-2 bersifat idempoten (XP tidak dobel!)
            const comp2 = await supertest(app)
                .post(`/api/v1/materials/${mat1BInProgressId}/complete`)
                .set('Authorization', `Bearer ${studentToken}`)
                .expect(200);
            expect(comp2.body.data.xpEarned).toBe(0);

            // Overview sekarang mencatat 1 dari 3 materi rekomendasi sudah dituntaskan (33%)
            const ovRes = await supertest(app)
                .get('/api/v1/recommendations/overview')
                .set('Authorization', `Bearer ${studentToken}`)
                .expect(200);
            expect(ovRes.body.data.stats).toMatchObject({
                totalRecommended: 3,
                totalCompleted: 1,
                completionRate: 33,
                totalFeedback: 1,
            });

            // mat1B hilang dari rekomendasi aktif, TETAPI tetap tersimpan di Riwayat Rekomendasi dengan status 'completed' & feedback 'relevant'!
            const activeRes = await supertest(app)
                .get('/api/v1/recommendations')
                .set('Authorization', `Bearer ${studentToken}`)
                .expect(200);
            expect(
                activeRes.body.data.some((i: any) => i.material.id === mat1BInProgressId)
            ).toBe(false);

            const historyRes = await supertest(app)
                .get('/api/v1/recommendations/history?search=Rantai%20Makanan')
                .set('Authorization', `Bearer ${studentToken}`)
                .expect(200);

            expect(historyRes.body.data.length).toBe(1);
            expect(historyRes.body.data[0]).toMatchObject({
                materialId: mat1BInProgressId,
                learningStatus: 'completed',
                progressPercent: 100,
                feedback: 'relevant',
            });
            expect(historyRes.body.meta.totalItems).toBe(1);
        });
    });
});
