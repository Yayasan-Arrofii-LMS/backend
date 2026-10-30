const WORDS_PER_MINUTE = 180;

/**
 * Menghapus tag HTML dan merapikan spasi dari konten rich-text materi.
 */
export function stripHtmlTags(raw?: string | null): string {
    if (!raw) return '';

    return raw
        .replace(/<script[\s\S]*?>[\s\S]*?<\/script>/gi, ' ')
        .replace(/<style[\s\S]*?>[\s\S]*?<\/style>/gi, ' ')
        .replace(/<[^>]+>/g, ' ')
        .replace(/&nbsp;/gi, ' ')
        .replace(/&amp;/gi, '&')
        .replace(/&lt;/gi, '<')
        .replace(/&gt;/gi, '>')
        .replace(/&quot;/gi, '"')
        .replace(/&#39;/gi, "'")
        .replace(/\s+/g, ' ')
        .trim();
}

/**
 * Mengekstrak cuplikan deskripsi bersih (plain-text) untuk kartu rekomendasi & banner.
 */
export function extractMaterialExcerpt(content?: string | null, maxLength: number = 150): string {
    const plain = stripHtmlTags(content);
    if (!plain) return '';
    if (plain.length <= maxLength) return plain;

    const sliced = plain.slice(0, maxLength);
    const lastSpaceIdx = sliced.lastIndexOf(' ');
    const safeCut = lastSpaceIdx > Math.floor(maxLength * 0.6) ? sliced.slice(0, lastSpaceIdx) : sliced;

    return `${safeCut.trim()}...`;
}

/**
 * Precomputation estimasi durasi belajar (dalam menit) berdasarkan panjang kata & tipe media.
 * Dipanggil satu kali saat create/update materi (write-time) atau sebagai fallback ringan.
 */
export function estimateMaterialDuration(params: {
    content?: string | null;
    mediaType?: string | null;
    videoLink?: string | null;
}): number {
    const plain = stripHtmlTags(params.content);
    const wordCount = plain ? plain.split(/\s+/).filter(Boolean).length : 0;
    const readingMinutes = wordCount > 0 ? Math.ceil(wordCount / WORDS_PER_MINUTE) : 0;

    const media = (params.mediaType ?? '').trim().toLowerCase();
    const hasVideo = media === 'video' || Boolean(params.videoLink && params.videoLink.trim().length > 0);

    if (hasVideo) {
        return Math.max(10, 12 + Math.max(0, readingMinutes - 1));
    }

    if (media === 'pdf' || media === 'modul praktik' || media === 'materi interaktif') {
        return Math.max(10, readingMinutes);
    }

    return Math.max(5, readingMinutes);
}

/**
 * Mengambil thumbnail materi dari gambar pertama di konten HTML (non-base64)
 * atau fallback ke gambar sampul Kelas (`Class.image_path`).
 */
export function resolveMaterialThumbnail(
    content?: string | null,
    classImagePath?: string | null
): string | null {
    const appUrl = (process.env.APP_URL || 'http://localhost').replace(/\/$/, '');

    if (content) {
        const imgMatch = content.match(/<img[^>]+src=["']([^"']+)["']/i);
        const rawSrc = imgMatch?.[1]?.trim();
        if (rawSrc && !rawSrc.startsWith('data:')) {
            if (/^https?:\/\//i.test(rawSrc)) {
                return rawSrc;
            }
            return `${appUrl}/${rawSrc.replace(/^\/+/, '')}`;
        }
    }

    if (classImagePath && classImagePath.trim().length > 0) {
        const trimmed = classImagePath.trim();
        if (/^https?:\/\//i.test(trimmed)) {
            return trimmed;
        }
        return `${appUrl}/${trimmed.replace(/^\/+/, '')}`;
    }

    return null;
}
