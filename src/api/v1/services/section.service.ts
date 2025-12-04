import { Section, Material_File } from '@prisma/client';
import { CreateSectionInput, UpdateSectionInput } from '../schemas/section.schema';
import prisma from '../../../database';
import { generateFileToken } from '../helpers/fileToken';

type MaterialFileWithUrl = Material_File & { url: string };

type SectionMaterial = {
    id: number;
    title: string;
    content: string;
    Material_File: { 
        id: number; 
        path: string;
        title: string;
        createdAt: Date;
        updatedAt: Date;
        materialId: number;
    }[];
};

type SectionMaterialWithUrl = {
    id: number;
    title: string;
    content: string;
    Material_File: MaterialFileWithUrl[];
};

type SectionData = {
    id: number;
    title: string;
    description: string | null;
    video_link: string | null;
    order: number;
    Material: SectionMaterial[];
    Quiz: {
        id: number;
        title: string;
        description: string;
        close_at: Date;
        open_at: Date;
    }[];
};

type SectionDataWithUrl = Omit<SectionData, 'Material'> & {
    Material: SectionMaterialWithUrl[];
};

class SectionService {
    private transformMaterialFiles(sections: SectionData[]): SectionDataWithUrl[] {
        const appUrl = (process.env.APP_URL || "http://localhost").replace(/\/$/, "");

        return sections.map(section => ({
            ...section,
            Material: section.Material.map((material) => ({
                ...material,
                Material_File: material.Material_File.map((file) => ({
                    ...file,
                    url: `${appUrl}/files/protected/${generateFileToken(file.path, 60)}`
                }))
            }))
        }));
    }

    async getAllSections(classId: string): Promise<SectionDataWithUrl[]> {
        try {
            const sections = await prisma.section.findMany({
                where: { classId: parseInt(classId) },
                orderBy: { order: 'asc' },
                select: {
                    id: true,
                    title: true,
                    description: true,
                    video_link: true,
                    order: true,
                    Material: {
                        select: {
                            id: true,
                            title: true,
                            content: true,
                            Material_File: {
                                select: {
                                    id: true,
                                    path: true,
                                    title: true,
                                    createdAt: true,
                                    updatedAt: true,
                                    materialId: true,
                                },
                            },
                        },
                    },
                    Quiz: {
                        select: {
                            id: true,
                            title: true,
                            description: true,
                            close_at: true,
                            open_at: true,
                        }
                    }
                }
            });
            return this.transformMaterialFiles(sections);
        } catch (error: unknown) {
            const message = error instanceof Error ? error.message : 'Unknown error';
            throw new Error(`Failed to fetch sections: ${message}`);
        }
    }

    async getAllSectionsPublic(classId: string): Promise<Partial<Section>[]> {
        try {
            return await prisma.section.findMany({
                where: { classId: parseInt(classId) },
                orderBy: { order: 'asc' },
                select: {
                    id: true,
                    title: true,
                    description: true,
                    video_link: true,
                    order: true,
                    Material: {
                        select: {
                            id: true,
                            title: true,
                        },
                    },
                    Quiz: {
                        select: {
                            id: true,
                            title: true,
                        }
                    }
                }
            });
        } catch (error: unknown) {
            const message = error instanceof Error ? error.message : 'Unknown error';
            throw new Error(`Failed to fetch sections: ${message}`);
        }
    }

    async getSectionById(sectionId: string): Promise<Section> {
        try {
            const section = await prisma.section.findUnique({
                where: { id: parseInt(sectionId) },
                include: {
                    Material: true,
                    Assignment: true,
                    Quiz: true,
                },
            });
            if (!section) {
                throw new Error('Section not found');
            }
            return section;
        } catch (error: unknown) {
            const message = error instanceof Error ? error.message : 'Unknown error';
            throw new Error(`Failed to fetch section: ${message}`);
        }
    }

    async createSection(data: CreateSectionInput, classId: number): Promise<Section> {
        try {
            const lastSection = await prisma.section.findFirst({
                where: { classId },
                orderBy: { order: 'desc' },
            });

            const newOrder = lastSection ? lastSection.order + 1 : 1;

            return await prisma.section.create({
                data: {
                    title: data.title,
                    description: data.description,
                    video_link: data.video_link,
                    classId,
                    order: newOrder,
                },
            });
        } catch (error: unknown) {
            const message = error instanceof Error ? error.message : 'Unknown error';
            throw new Error(`Failed to create section: ${message}`);
        }
    }

    async updateSection(sectionId: string, data: UpdateSectionInput): Promise<Section> {
        try {
            const section = await prisma.section.findUnique({
                where: { id: parseInt(sectionId) },
            });
            if (!section) {
                throw new Error('Section not found');
            }
            return await prisma.section.update({
                where: { id: parseInt(sectionId) },
                data,
            });
        } catch (error: unknown) {
            const message = error instanceof Error ? error.message : 'Unknown error';
            throw new Error(`Failed to update section: ${message}`);
        }
    }

    async deleteSection(sectionId: string): Promise<Section> {
        try {
            const section = await prisma.section.findUnique({
                where: { id: parseInt(sectionId) },
            });
            if (!section) {
                throw new Error('Section not found');
            }
            return await prisma.section.delete({
                where: { id: parseInt(sectionId) },
            });
        } catch (error: unknown) {
            const message = error instanceof Error ? error.message : 'Unknown error';
            throw new Error(`Failed to delete section: ${message}`);
        }
    }
}

export default new SectionService();