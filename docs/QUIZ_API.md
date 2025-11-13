# Quiz API Documentation

## Overview
Fitur quiz yang telah diperbaharui dengan sistem auto-save dan validasi waktu real-time.

## Fitur Utama
1. **Auto-save Jawaban** - Setiap jawaban disimpan langsung ke database
2. **Validasi Waktu** - Memastikan quiz masih dalam waktu yang ditentukan
3. **Kalkulasi Nilai** - Nilai dikalkulasi saat submit atau saat melihat hasil
4. **Auto-submit** - Quiz akan otomatis di-submit jika waktu habis

---

## Endpoints

### Teacher Endpoints

#### 1. Create Quiz
```http
POST /api/v1/quizzes
Authorization: Bearer {token}
Role: Teacher
```

**Request Body:**
```json
{
  "title": "Quiz Matematika Bab 1",
  "description": "Quiz tentang persamaan linear",
  "max_attempts": 3,
  "time_limit": 60,
  "open_at": "2025-11-13T10:00:00Z",
  "close_at": "2025-11-13T12:00:00Z",
  "passing_grade": 70,
  "xp": 100,
  "sectionId": 1
}
```

**Response:**
```json
{
  "success": true,
  "message": "Quiz created",
  "data": {
    "id": 1,
    "title": "Quiz Matematika Bab 1",
    "description": "Quiz tentang persamaan linear",
    "max_attempts": 3,
    "time_limit": 60,
    "open_at": "2025-11-13T10:00:00.000Z",
    "close_at": "2025-11-13T12:00:00.000Z",
    "passing_grade": 70,
    "xp": 100,
    "sectionId": 1,
    "createdAt": "2025-11-13T09:00:00.000Z",
    "updatedAt": "2025-11-13T09:00:00.000Z"
  }
}
```

#### 2. Get Quiz Details
```http
GET /api/v1/quizzes/:id
Authorization: Bearer {token}
Role: Teacher
```

#### 3. Update Quiz
```http
PUT /api/v1/quizzes/:id
Authorization: Bearer {token}
Role: Teacher
```

#### 4. Delete Quiz
```http
DELETE /api/v1/quizzes/:id
Authorization: Bearer {token}
Role: Teacher
```

#### 5. Add Question
```http
POST /api/v1/quizzes/:quizId/questions
Authorization: Bearer {token}
Role: Teacher
```

**Request Body (Multiple Choice):**
```json
{
  "question": "Berapa hasil dari 2 + 2?",
  "type": "MultipleChoice",
  "points": 10,
  "answers": [
    { "answer": "3", "is_correct": false },
    { "answer": "4", "is_correct": true },
    { "answer": "5", "is_correct": false }
  ]
}
```

**Request Body (True/False):**
```json
{
  "question": "Bumi itu bulat",
  "type": "TrueFalse",
  "points": 5,
  "answers": [
    { "answer": "True", "is_correct": true },
    { "answer": "False", "is_correct": false }
  ]
}
```

**Request Body (Essay):**
```json
{
  "question": "Jelaskan tentang fotosintesis",
  "type": "Essay",
  "points": 20
}
```

#### 6. Update Question
```http
PUT /api/v1/quizzes/questions/:questionId
Authorization: Bearer {token}
Role: Teacher
```

#### 7. Delete Question
```http
DELETE /api/v1/quizzes/questions/:questionId
Authorization: Bearer {token}
Role: Teacher
```

---

### Student Endpoints

#### 1. Start Quiz Attempt
```http
POST /api/v1/quizzes/start
Authorization: Bearer {token}
Role: Student
```

**Request Body:**
```json
{
  "quizId": 1
}
```

**Response:**
```json
{
  "success": true,
  "message": "Quiz attempt started",
  "data": {
    "id": 1,
    "userId": "uuid-user",
    "quizId": 1,
    "score": null,
    "started_at": "2025-11-13T10:05:00.000Z",
    "submitted_at": null,
    "is_graded": false,
    "quiz": {
      "id": 1,
      "title": "Quiz Matematika Bab 1",
      "description": "Quiz tentang persamaan linear",
      "time_limit": 60,
      "quiz_question": [
        {
          "id": 1,
          "question": "Berapa hasil dari 2 + 2?",
          "type": "MultipleChoice",
          "points": 10,
          "quiz_answer": [
            { "id": 1, "answer": "3", "is_correct": false },
            { "id": 2, "answer": "4", "is_correct": true },
            { "id": 3, "answer": "5", "is_correct": false }
          ]
        }
      ]
    }
  }
}
```

**Notes:**
- Jika student sudah memiliki attempt yang sedang berjalan dan waktu belum habis, endpoint ini akan mengembalikan attempt yang sudah ada
- Jika waktu sudah habis, attempt lama akan otomatis di-submit dan attempt baru akan dibuat
- Memvalidasi bahwa quiz masih dalam periode open_at dan close_at
- Memvalidasi bahwa student belum mencapai max_attempts

#### 2. Save Answer (Auto-save)
```http
POST /api/v1/quizzes/save-answer
Authorization: Bearer {token}
Role: Student
```

**Request Body (Multiple Choice):**
```json
{
  "attemptId": 1,
  "questionId": 1,
  "selectedAnswerIds": [2]
}
```

**Request Body (True/False):**
```json
{
  "attemptId": 1,
  "questionId": 2,
  "answer": "True"
}
```

**Request Body (Essay):**
```json
{
  "attemptId": 1,
  "questionId": 3,
  "answer": "Fotosintesis adalah proses...",
  "filePath": "https://example.com/uploads/essay.pdf"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Answer saved",
  "data": {
    "id": 1,
    "attemptId": 1,
    "questionId": 1,
    "answer": null,
    "path": null,
    "quiz_question": {
      "id": 1,
      "question": "Berapa hasil dari 2 + 2?",
      "type": "MultipleChoice",
      "points": 10
    },
    "attemp_multiple_answer": [
      {
        "id": 1,
        "answerId": 2,
        "quiz_answer": {
          "id": 2,
          "answer": "4",
          "is_correct": true
        }
      }
    ]
  }
}
```

**Notes:**
- Endpoint ini akan menyimpan/update jawaban secara real-time
- Memvalidasi bahwa quiz masih dalam waktu (time_limit belum habis)
- Memvalidasi bahwa quiz belum di-submit
- Memvalidasi bahwa quiz masih dalam periode close_at

#### 3. Submit Quiz
```http
POST /api/v1/quizzes/submit
Authorization: Bearer {token}
Role: Student
```

**Request Body:**
```json
{
  "attemptId": 1
}
```

**Response:**
```json
{
  "success": true,
  "message": "Quiz submitted successfully",
  "data": {
    "id": 1,
    "userId": "uuid-user",
    "quizId": 1,
    "score": 80,
    "started_at": "2025-11-13T10:05:00.000Z",
    "submitted_at": "2025-11-13T10:45:00.000Z",
    "is_graded": true,
    "quiz": {
      "id": 1,
      "title": "Quiz Matematika Bab 1",
      "passing_grade": 70,
      "xp": 100
    },
    "attemp_answer": [...]
  }
}
```

**Notes:**
- Endpoint ini akan melakukan submit final dan kalkulasi nilai
- Nilai akan otomatis terkalkulasi untuk soal Multiple Choice dan True/False
- Untuk soal Essay, nilai akan null sampai teacher memberikan nilai manual (is_graded = false)
- Setelah submit, tidak bisa mengubah jawaban lagi

#### 4. Get Attempt Result
```http
GET /api/v1/quizzes/attempts/:attemptId/result
Authorization: Bearer {token}
Role: Student
```

**Response:**
```json
{
  "success": true,
  "message": "Attempt result retrieved",
  "data": {
    "id": 1,
    "userId": "uuid-user",
    "quizId": 1,
    "score": 80,
    "started_at": "2025-11-13T10:05:00.000Z",
    "submitted_at": "2025-11-13T10:45:00.000Z",
    "is_graded": true,
    "quiz": {
      "id": 1,
      "title": "Quiz Matematika Bab 1",
      "passing_grade": 70,
      "xp": 100,
      "quiz_question": [...]
    },
    "attemp_answer": [
      {
        "id": 1,
        "questionId": 1,
        "answer": null,
        "quiz_question": {
          "id": 1,
          "question": "Berapa hasil dari 2 + 2?",
          "type": "MultipleChoice",
          "points": 10
        },
        "attemp_multiple_answer": [
          {
            "quiz_answer": {
              "answer": "4",
              "is_correct": true
            }
          }
        ]
      }
    ]
  }
}
```

**Notes:**
- Endpoint ini akan menampilkan hasil quiz
- Jika quiz belum di-graded (ada essay), akan mencoba kalkulasi ulang
- Menampilkan detail jawaban student dan jawaban yang benar

#### 5. Get My Attempts
```http
GET /api/v1/quizzes/my-attempts/:quizId
Authorization: Bearer {token}
Role: Student
```

**Response:**
```json
{
  "success": true,
  "message": "Your attempts",
  "data": [
    {
      "id": 1,
      "userId": "uuid-user",
      "quizId": 1,
      "score": 80,
      "started_at": "2025-11-13T10:05:00.000Z",
      "submitted_at": "2025-11-13T10:45:00.000Z",
      "is_graded": true
    },
    {
      "id": 2,
      "userId": "uuid-user",
      "quizId": 1,
      "score": 90,
      "started_at": "2025-11-13T11:05:00.000Z",
      "submitted_at": "2025-11-13T11:35:00.000Z",
      "is_graded": true
    }
  ],
  "meta": {
    "totalItems": 2,
    "itemsPerPage": 2,
    "totalPages": 1,
    "currentPage": 1
  }
}
```

---

## Flow Pengerjaan Quiz

### 1. Student Memulai Quiz
```
POST /api/v1/quizzes/start
{
  "quizId": 1
}
```
- System akan membuat Quiz_Attempt baru dengan `started_at` = now
- System akan return quiz questions tanpa menampilkan jawaban yang benar
- System akan check validasi (open_at, close_at, max_attempts)

### 2. Student Menjawab Soal (Auto-save)
```
POST /api/v1/quizzes/save-answer
{
  "attemptId": 1,
  "questionId": 1,
  "selectedAnswerIds": [2]
}
```
- Setiap kali student menjawab, jawaban langsung disimpan ke database
- System akan check apakah waktu masih cukup
- Jika jawaban sudah ada, akan di-update
- Tidak ada batasan berapa kali bisa save answer

### 3. Student Submit Quiz
```
POST /api/v1/quizzes/submit
{
  "attemptId": 1
}
```
- System akan set `submitted_at` = now
- System akan kalkulasi nilai untuk soal Multiple Choice dan True/False
- System akan set `is_graded` = true jika tidak ada essay, atau false jika ada essay
- Setelah submit, tidak bisa mengubah jawaban

### 4. Student Melihat Hasil
```
GET /api/v1/quizzes/attempts/1/result
```
- System akan menampilkan hasil quiz
- Jika belum di-graded, system akan coba kalkulasi ulang
- Menampilkan detail jawaban dan skor

---

## Database Schema Changes

### Quiz_Attempt Table
```sql
model Quiz_Attempt {
  id            Int             @id @default(autoincrement())
  score         Int?            -- Nullable, bisa null jika ada essay belum dinilai
  started_at    DateTime        @default(now())  -- Waktu mulai attempt
  submitted_at  DateTime?       -- Waktu submit, null jika belum submit
  is_graded     Boolean         @default(false)  -- True jika sudah dinilai semua
  createdAt     DateTime        @default(now())
  updatedAt     DateTime        @updatedAt
  userId        String
  quizId        Int
  User          User            @relation(fields: [userId], references: [id])
  quiz          Quiz            @relation(fields: [quizId], references: [id])
  attemp_answer Attemp_Answer[]
}
```

---

## Error Messages

### Start Quiz Attempt
- `"Quiz belum dibuka"` - Quiz belum mencapai open_at
- `"Quiz sudah ditutup"` - Quiz sudah melewati close_at
- `"Maksimal percobaan telah tercapai"` - Student sudah mencapai max_attempts

### Save Answer
- `"Attempt tidak ditemukan"` - attemptId tidak valid
- `"Anda tidak memiliki akses ke attempt ini"` - User bukan pemilik attempt
- `"Quiz sudah di-submit"` - Attempt sudah di-submit
- `"Waktu quiz telah habis"` - Melebihi time_limit
- `"Quiz sudah ditutup"` - Quiz sudah melewati close_at

### Submit Quiz
- `"Attempt tidak ditemukan"` - attemptId tidak valid
- `"Anda tidak memiliki akses ke attempt ini"` - User bukan pemilik attempt
- `"Quiz sudah di-submit"` - Attempt sudah di-submit sebelumnya

### Get Attempt Result
- `"Attempt tidak ditemukan"` - attemptId tidak valid
- `"Anda tidak memiliki akses ke attempt ini"` - User bukan pemilik attempt

---

## Migration Command

```bash
npx prisma migrate dev --name add_quiz_attempt_fields
```

Ini sudah dijalankan dan membuat migration file di:
`src/database/migrations/20251113042216_add_quiz_attempt_fields/migration.sql`
