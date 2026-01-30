import { BulkCreateQuestionsInput } from './src/api/v1/schemas/quiz.schema';

// Sample data untuk bulk create quiz dengan berbagai tipe pertanyaan
export const sampleBulkCreateQuiz: BulkCreateQuestionsInput = {
  title: "Biologi - Sistem Pernapasan Manusia",
  description: "Quiz komprehensif tentang sistem pernapasan manusia mencakup anatomi, fisiologi, dan penyakit",
  max_attempts: 2,
  time_limit: 45,
  open_at: new Date("2026-01-30T08:00:00Z"),
  close_at: new Date("2026-02-06T23:59:59Z"),
  passing_grade: 75,
  xp: 150,
  questions: [
    {
      question: "Organ manakah yang bertanggung jawab untuk pertukaran gas di paru-paru?",
      type: "MultipleChoice",
      points: 15,
      explanation: "Alveoli adalah struktur kecil di paru-paru tempat terjadi pertukaran oksigen dan karbon dioksida",
      answers: [
        {
          answer: "Bronkus",
          is_correct: false
        },
        {
          answer: "Alveoli",
          is_correct: true
        },
        {
          answer: "Trakea",
          is_correct: false
        },
        {
          answer: "Diafragma",
          is_correct: false
        }
      ]
    },
    {
      question: "Proses pernapasan melibatkan paru-paru dan diafragma saja",
      type: "TrueFalse",
      points: 10,
      explanation: "Salah, proses pernapasan juga melibatkan otot-otot antar rusuk dan organ pernapasan lainnya"
    },
    {
      question: "Jelaskan perbedaan antara pernapasan dada dan pernapasan perut, serta kapan masing-masing terjadi",
      type: "Essay",
      points: 25,
      explanation: "Pernapasan dada menggunakan otot-otot antar rusuk (inspirasi paksa), biasanya saat aktivitas berat. Pernapasan perut menggunakan diafragma (inspirasi normal), biasanya saat istirahat. Keduanya penting untuk supplai oksigen yang efisien."
    },
    {
      question: "Berapa banyak paru-paru yang dimiliki manusia?",
      type: "MultipleChoice",
      points: 10,
      explanation: "Manusia memiliki 2 paru-paru: paru-paru kanan (3 lobus) dan paru-paru kiri (2 lobus)",
      answers: [
        {
          answer: "1",
          is_correct: false
        },
        {
          answer: "2",
          is_correct: true
        },
        {
          answer: "3",
          is_correct: false
        },
        {
          answer: "4",
          is_correct: false
        }
      ]
    },
    {
      question: "Oksigen yang masuk ke dalam tubuh langsung bisa digunakan oleh semua sel",
      type: "TrueFalse",
      points: 10,
      explanation: "Salah, oksigen harus diangkut oleh hemoglobin dalam darah ke seluruh sel tubuh sebelum bisa digunakan"
    },
    {
      question: "Manakah gas yang diproduksi sebagai limbah dalam pernapasan seluler?",
      type: "MultipleChoice",
      points: 15,
      explanation: "Karbon dioksida (CO2) adalah produk sampingan dari pernapasan seluler yang harus dikeluarkan dari tubuh",
      answers: [
        {
          answer: "Nitrogen",
          is_correct: false
        },
        {
          answer: "Oksigen",
          is_correct: false
        },
        {
          answer: "Karbon dioksida",
          is_correct: true
        },
        {
          answer: "Hidrogen",
          is_correct: false
        }
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
  questions: [
    {
      question: "Hukum Newton yang menyatakan bahwa gaya sama dengan massa dikali percepatan adalah?",
      type: "MultipleChoice",
      points: 20,
      explanation: "F = ma adalah Hukum Newton Kedua",
      answers: [
        {
          answer: "Hukum Newton Pertama",
          is_correct: false
        },
        {
          answer: "Hukum Newton Kedua",
          is_correct: true
        },
        {
          answer: "Hukum Newton Ketiga",
          is_correct: false
        }
      ]
    },
    {
      question: "Setiap aksi selalu diikuti oleh reaksi yang sama besar tetapi berlawanan arah",
      type: "TrueFalse",
      points: 15,
      explanation: "Benar, ini adalah pernyataan Hukum Newton Ketiga"
    }
  ]
};
