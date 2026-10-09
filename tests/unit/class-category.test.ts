import { createClassSchema } from '../../src/api/v1/schemas/class.schema';
import { createMaterialSchema, updateMaterialSchema } from '../../src/api/v1/schemas/material.schema';
import { updateMaterialMetadataSchema } from '../../src/api/v1/schemas/materialMetadata.schema';

describe('Class & Material Category Feature Tests', () => {
    describe('createClassSchema', () => {
        it('should accept valid numeric categoryId', () => {
            const result = createClassSchema.parse({
                name: 'Kelas Robotika',
                description: 'Belajar robotika dasar',
                categoryId: 1,
            });
            expect(result.categoryId).toBe(1);
        });

        it('should coerce string categoryId to number', () => {
            const result = createClassSchema.parse({
                name: 'Kelas Robotika',
                description: 'Belajar robotika dasar',
                categoryId: '3' as unknown as number,
            });
            expect(result.categoryId).toBe(3);
        });

        it('should allow null or undefined categoryId', () => {
            const withNull = createClassSchema.parse({
                name: 'Kelas Umum',
                categoryId: null,
            });
            expect(withNull.categoryId).toBeNull();

            const withUndefined = createClassSchema.parse({
                name: 'Kelas Umum',
            });
            expect(withUndefined.categoryId).toBeUndefined();
        });

        it('should reject non-positive categoryId', () => {
            expect(() => {
                createClassSchema.parse({
                    name: 'Kelas Invalid',
                    categoryId: -1,
                });
            }).toThrow();

            expect(() => {
                createClassSchema.parse({
                    name: 'Kelas Invalid',
                    categoryId: 0,
                });
            }).toThrow();
        });
    });

    describe('Material Schemas', () => {
        it('createMaterialSchema should accept categoryId and nullable', () => {
            const withCat = createMaterialSchema.parse({
                title: 'Pengantar Sains',
                content: 'Isi materi sains',
                categoryId: 2,
            });
            expect(withCat.categoryId).toBe(2);

            const withNull = createMaterialSchema.parse({
                title: 'Materi Tanpa Kategori',
                content: 'Isi materi umum',
                categoryId: null,
            });
            expect(withNull.categoryId).toBeNull();
        });

        it('updateMaterialSchema should allow optional categoryId', () => {
            const updated = updateMaterialSchema.parse({
                categoryId: 5,
            });
            expect(updated.categoryId).toBe(5);

            const cleared = updateMaterialSchema.parse({
                categoryId: null,
            });
            expect(cleared.categoryId).toBeNull();
        });

        it('updateMaterialMetadataSchema should validate categoryId correctly', () => {
            const metadata = updateMaterialMetadataSchema.parse({
                categoryId: 4,
                difficulty: 'Medium',
                mediaType: 'Video',
            });
            expect(metadata.categoryId).toBe(4);
            expect(metadata.difficulty).toBe('Medium');
        });
    });
});
