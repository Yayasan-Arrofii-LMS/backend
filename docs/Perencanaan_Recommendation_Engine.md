# PERENCANAAN — Recommendation Engine (Phase 3, sesuai PRD §9/§10/§20-§22/§24/§28)

> Scope: cuma `GET /recommendations`. Fondasi sudah done di `dev` (Category dual Class+Material + auto-inherit, UserInterest, MaterialActivity, metadata difficulty/mediaType, seed kategori, 14 migrations). Tanpa migration baru, tanpa ubah schema.prisma.
> Branch kerja: dari `dev`, mis. `feat-recommendation`. Done = `npm run build` OK + checklist Postman lolos.

## 1. Tujuan (PRD §9 + §28)

Memberi rekomendasi materi relevan dari profil/minat/aktivitas/progres/hasil evaluasi. Tahap awal rule-based + content-based filtering. ML/collaborative/hybrid = Phase 6, jangan masuk.

## 2. Scope Phase 3 yang dikerjakan (PRD §21)

- Recommendation Engine + 4 jenis: minat, progres, remedial, lanjutan.
- YANG DIKERJAKAN: engine + list + alasan.
- TIDAK DIKERJAKAN (Phase 6): kuis adaptif, feedback (`POST /recommendations/:id/feedback`), history, analisis relevansi, Precision@K/Recall@K/F1@K, ML.

## 3. FR (PRD §9.4 + §10)

- FR-PR15: kandidat dari data siswa. FR-PR16/17/18/19: minat, progres, remedial, lanjutan. FR-PR20: prioritaskan yang relevan. FR-PR21: deprioritaskan completed (kecuali remedial-repeat, lihat §6). FR-PR22: hanya materi yang bisa diakses siswa. FR-PR23: tampilkan alasan. FR-PR24: tampil di dashboard. FR-PR25: catat interaksi (pakai MaterialActivity `opened`, tanpa tabel baru).
- FR-R01–R06: remedial dari hasil kuis/tugas, ambang = `Quiz.passing_grade` (bukan angka global), tampil di halaman belajar, guru bisa lihat (via data sama).

## 4. Data yang dipakai (PRD §19, existing — tanpa tabel baru)

- `UserInterest` → set categoryIds minat.
- `MaterialActivity(action=completed/opened)` → progres + interaksi.
- `Quiz_Attempt(score, is_graded, submitted_at)` + `Quiz(passing_grade, sectionId)` → remedial.
- `Material(categoryId, difficulty, mediaType, sectionId)` + `Class(categoryId)` → kandidat + label.
- Akses materi: ikut enrollment existing (verifyEnrollmentBySection). Jangan bikin auth baru.

## 5. API (PRD §20)

- `GET /recommendations?limit=` (default 10, max 50). Auth: semua role baca milik sendiri via `req.user.id`, tanpa `verifyRole`.
- Response per item: `{ material, reasons: ("remedial"|"minat"|"lanjutan")[], score, repeat?: boolean }`. `reasons` WAJIB (FR-PR23), bisa >1.

## 6. Rules scoring

- +3 remedial: attempt terakhir per quiz yang `is_graded + submitted_at` terisi dan `score < passing_grade` → materi se-section yang belum completed.
- Edge case (disepakati): kalau section gagal tapi materinya sudah completed semua → tetap tampilkan ulang, urut paling lama completed duluan, `reasons: ["remedial"]`, tambah `repeat: true`. Remedial ngalahin filter completed.
- +2 minat: `material.categoryId` ∈ minat user.
- +1 lanjutan: materi di section yang belum pernah completed sama sekali.
- −99 selesai: sudah `completed` (kecuali remedial-repeat di atas). Jangan filter habis — deprioritaskan saja (FR-PR21).
- Urut: score desc, lalu remedial dulu, lalu terbaru.

## 7. File yang dibuat/diubah (ikuti pola layer existing)

- Baru: `services/recommendation.service.ts` (logic + skor di memory, tanpa raw SQL), `controllers/recommendation.controller.ts` (1 handler, try/catch + sendResponse), `routes/recommendation.route.ts` + mount `router.use("/recommendations", authMiddleware, recommendationRouter)` di `index.route.ts`.
- Ubah: tidak ada (selain mount route). Jangan sentuh material/quiz/userInterest/activity.
- `ponytail:` complete endpoint belum ada — `logCompleted` dipanggil phase complete; upgrade path: `POST /materials/:id/complete`.

## 8. Acceptance (PRD §22 personalisasi)

- Minat tersimpan, aktivitas/progres tercatat, materi punya metadata — sudah (fondasi).
- Engine: bisa beda jenis, ada alasan, tidak tampilkan yang tak bisa diakses, ke-update habis aktivitas (cukup baca ulang MaterialActivity tiap request, tanpa cache).

## 9. Metrics (PRD §24 personalization)

- Ukur: open rate, completion rate, % rekomendasi dipilih/diselesaikan, % ada alasan. Precision@K/Recall@K/F1@K SKIP (belum ada ground truth).

## 10. Out of scope (PRD §23 + §6.6)

ML, collaborative/hybrid filtering, feedback endpoint, history, workshop/forum/offline-first, Topic/Kompetensi/Prasyarat tabel baru.

## 11. Verifikasi

- `npm run build` sukses tanpa error tsc.
- Postman (login → Bearer):
  - [ ] `GET /recommendations` → 200 array `{ material, reasons, score }`.
  - [ ] Setelah PUT interests + buka materi → `reasons` berisi `minat`/`lanjutan`.
  - [ ] Remedial: buat attempt di bawah passing_grade → materi se-section muncul `reasons: ["remedial"]` paling atas. Kalau section sudah completed semua → tetap muncul dengan `repeat: true`.
  - [ ] Tanpa data quiz → hanya `minat`/`lanjutan`, tanpa error.

## 12. Larangan

- ❌ migration baru / ubah schema / reset / seed / upgrade Prisma / `audit fix --force`.
- ❌ `verifyRole(["Admin"])` di `/recommendations`.
- ❌ raw SQL (data masih kecil, skor di memory).
- ❌ commit `.env`, print secret.
