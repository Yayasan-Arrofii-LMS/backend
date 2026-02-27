import app from "./index";
// Uncomment to enable automatic image cleanup cron job
// import { startImageCleanupJob } from "./jobs/imageCleanup.job";

const PORT = process.env.PORT || 3001;

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  
  // Start cron jobs (only in production)
  if (process.env.NODE_ENV === 'production') {
    // Uncomment to enable automatic cleanup
    // startImageCleanupJob();
  }
});
