// import cron from 'node-cron';
// import materialImageService from '../api/v1/services/materialImage.service';

// /**
//  * Image Cleanup Cron Job
//  * Runs daily at 2 AM to cleanup unused images older than 7 days
//  */
// export function startImageCleanupJob() {
//     // Schedule: Run every day at 2:00 AM
//     // Format: second minute hour day month weekday
//     // '0 2 * * *' = At 02:00 every day
//     cron.schedule('0 2 * * *', async () => {
//         console.log('[Cron Job] Starting image cleanup job...');
//         console.log(`[Cron Job] Time: ${new Date().toISOString()}`);
        
//         try {
//             const daysThreshold = parseInt(process.env.IMAGE_CLEANUP_DAYS || '7');
//             const result = await materialImageService.cleanupUnusedImages(daysThreshold);
            
//             console.log('[Cron Job] Image cleanup completed successfully');
//             console.log(`[Cron Job] Images deleted: ${result.deleted}`);
//             console.log(`[Cron Job] Deleted files:`, result.images);
            
//             // Optional: Send notification to admin
//             // await sendAdminNotification({
//             //     type: 'IMAGE_CLEANUP',
//             //     deletedCount: result.deleted,
//             //     deletedFiles: result.images
//             // });
            
//         } catch (error) {
//             console.error('[Cron Job] Image cleanup job failed:', error);
            
//             // Optional: Send error notification to admin
//             // await sendErrorNotification({
//             //     job: 'IMAGE_CLEANUP',
//             //     error: error.message
//             // });
//         }
//     });

//     console.log('[Cron Job] Image cleanup job scheduled successfully');
//     console.log('[Cron Job] Schedule: Daily at 2:00 AM');
//     console.log(`[Cron Job] Days threshold: ${process.env.IMAGE_CLEANUP_DAYS || '7'} days`);
// }

// /**
//  * Optional: Manual cleanup trigger for admin
//  * Can be called via API endpoint
//  */
// export async function manualImageCleanup(daysThreshold: number = 7) {
//     console.log('[Manual Cleanup] Starting manual image cleanup...');
//     console.log(`[Manual Cleanup] Days threshold: ${daysThreshold}`);
    
//     try {
//         const result = await materialImageService.cleanupUnusedImages(daysThreshold);
        
//         console.log('[Manual Cleanup] Cleanup completed successfully');
//         console.log(`[Manual Cleanup] Images deleted: ${result.deleted}`);
        
//         return result;
//     } catch (error) {
//         console.error('[Manual Cleanup] Cleanup failed:', error);
//         throw error;
//     }
// }
