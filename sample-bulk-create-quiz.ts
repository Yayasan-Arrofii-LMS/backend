import { BulkCreateQuestionsInput } from './src/api/v1/schemas/quiz.schema';

// Sample data untuk bulk create quiz dengan berbagai tingkat kesulitan
export const sampleBulkCreateQuiz: BulkCreateQuestionsInput = {
  title: "Biologi - Sistem Pernapasan Manusia",
  description: "Quiz komprehensif tentang sistem pernapasan manusia mencakup anatomi, fisiologi, dan penyakit",
  max_attempts: 2,
  time_limit: 45,
  open_at: new Date("2026-01-30T08:00:00Z"),
  close_at: new Date("2026-02-06T23:59:59Z"),
  passing_grade: 75,
  xp: 150,
  show_review: true,
  questions: [
    {
      question: "Organ manakah yang bertanggung jawab untuk pertukaran gas di paru-paru?",
      type: "MultipleChoice",
      difficulty: "Easy",
      points: 1,
      explanation: "Alveoli adalah struktur kecil di paru-paru tempat terjadi pertukaran oksigen dan karbon dioksida",
      answers: [
        { answer: "Bronkus", is_correct: false },
        { answer: "Alveoli", is_correct: true },
        { answer: "Trakea", is_correct: false },
        { answer: "Diafragma", is_correct: false }
      ]
    },
    {
      question: "Proses pernapasan melibatkan paru-paru dan diafragma saja",
      type: "TrueFalse",
      difficulty: "Medium",
      points: 1,
      explanation: "Salah, proses pernapasan juga melibatkan otot-otot antar rusuk dan organ pernapasan lainnya",
      answers: [
        { answer: "True", is_correct: false },
        { answer: "False", is_correct: true }
      ]
    },
    {
      question: "Berapa banyak paru-paru yang dimiliki manusia?",
      type: "MultipleChoice",
      difficulty: "Easy",
      points: 1,
      explanation: "Manusia memiliki 2 paru-paru: paru-paru kanan (3 lobus) dan paru-paru kiri (2 lobus)",
      answers: [
        { answer: "1", is_correct: false },
        { answer: "2", is_correct: true },
        { answer: "3", is_correct: false },
        { answer: "4", is_correct: false }
      ]
    },
    {
      question: "Oksigen yang masuk ke dalam tubuh langsung bisa digunakan oleh semua sel",
      type: "TrueFalse",
      difficulty: "Hard",
      points: 1,
      explanation: "Salah, oksigen harus diangkut oleh hemoglobin dalam darah ke seluruh sel tubuh sebelum bisa digunakan",
      answers: [
        { answer: "True", is_correct: false },
        { answer: "False", is_correct: true }
      ]
    },
    {
      question: "Manakah gas yang diproduksi sebagai limbah dalam pernapasan seluler?",
      type: "MultipleChoice",
      difficulty: "Medium",
      points: 1,
      explanation: "Karbon dioksida (CO2) adalah produk sampingan dari pernapasan seluler yang harus dikeluarkan dari tubuh",
      answers: [
        { answer: "Nitrogen", is_correct: false },
        { answer: "Oksigen", is_correct: false },
        { answer: "Karbon dioksida", is_correct: true },
        { answer: "Hidrogen", is_correct: false }
      ]
    }
  ]
};

// Contoh lain: Quiz Fisika
export const samplePhysicsQuiz: BulkCreateQuestionsInput = {
  title: "Fisika - Hukum Newton",
  description: "Ujian tentang Hukum-hukum Newton dan aplikasinya",
  max_attempts: 3,
  time_limit: 60,
  open_at: new Date("2026-02-01T10:00:00Z"),
  close_at: new Date("2026-02-08T17:00:00Z"),
  passing_grade: 65,
  xp: 200,
  show_review: true,
  questions: [
    {
      question: "Hukum Newton yang menyatakan bahwa gaya sama dengan massa dikali percepatan adalah?",
      type: "MultipleChoice",
      difficulty: "Easy",
      points: 1,
      explanation: "F = ma adalah Hukum Newton Kedua",
      answers: [
        { answer: "Hukum Newton Pertama", is_correct: false },
        { answer: "Hukum Newton Kedua", is_correct: true },
        { answer: "Hukum Newton Ketiga", is_correct: false }
      ]
    },
    {
      question: "Setiap aksi selalu diikuti oleh reaksi yang sama besar tetapi berlawanan arah",
      type: "TrueFalse",
      difficulty: "Medium",
      points: 1,
      explanation: "Benar, ini adalah pernyataan Hukum Newton Ketiga",
      answers: [
        { answer: "True", is_correct: true },
        { answer: "False", is_correct: false }
      ]
    },
    {
      question: "Jika resultan gaya yang bekerja pada benda sama dengan nol, benda yang bergerak akan...",
      type: "MultipleChoice",
      difficulty: "Hard",
      points: 1,
      explanation: "Sesuai Hukum Newton I, benda bergerak lurus beraturan dengan kecepatan konstan",
      answers: [
        { answer: "Berhenti seketika", is_correct: false },
        { answer: "Bergerak dengan kecepatan konstan", is_correct: true },
        { answer: "Bergerak dengan percepatan tetap", is_correct: false }
      ]
    }
  ]
};
