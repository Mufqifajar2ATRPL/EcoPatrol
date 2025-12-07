import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';
import '../providers/report_provider.dart';
import 'edit_report_screen.dart';

class DetailReportScreen extends ConsumerWidget {
  final ReportModel report;

  const DetailReportScreen({Key? key, required this.report}) : super(key: key);

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Laporan'),
        content: const Text('Apakah Anda yakin ingin menghapus laporan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(reportProvider.notifier).deleteReport(report.id!);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to dashboard
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Laporan berhasil dihapus'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPending = report.status == 'pending';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Photo - Full Size
            Hero(
              tag: 'photo_${report.id}',
              child: Image.file(
                File(report.photoPath),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 64),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isPending
                          ? Colors.red.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isPending ? Colors.red : Colors.green,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPending ? Icons.pending : Icons.check_circle,
                          size: 18,
                          color: isPending ? Colors.red : Colors.green,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isPending ? 'PENDING' : 'SELESAI',
                          style: TextStyle(
                            color: isPending ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    report.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Date & Time
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.blue[700],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatDateTime(report.createdAt),
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Divider(),
                  const SizedBox(height: 16),

                  // Description Section
                  _buildInfoSection(
                    icon: Icons.description,
                    iconColor: Colors.orange,
                    title: 'Deskripsi Masalah',
                    content: report.description,
                  ),
                  const SizedBox(height: 20),

                  // Location Section
                  _buildInfoSection(
                    icon: Icons.location_on,
                    iconColor: Colors.red,
                    title: 'Koordinat Lokasi',
                    content:
                    'Latitude: ${report.latitude.toStringAsFixed(6)}\nLongitude: ${report.longitude.toStringAsFixed(6)}',
                  ),

                  // Completion Info (if completed)
                  if (!isPending) ...[
                    const SizedBox(height: 24),
                    const Divider(thickness: 2),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[700], size: 28),
                        const SizedBox(width: 8),
                        const Text(
                          'Informasi Penyelesaian',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildInfoSection(
                      icon: Icons.work_outline,
                      iconColor: Colors.green,
                      title: 'Deskripsi Pekerjaan',
                      content: report.completionDescription ?? '-',
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Icon(Icons.photo_camera, color: Colors.green[700]),
                        const SizedBox(width: 8),
                        const Text(
                          'Foto Hasil Pengerjaan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (report.completionPhotoPath != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(report.completionPhotoPath!),
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 64),
                            );
                          },
                        ),
                      ),
                  ],

                  const SizedBox(height: 80), // Space for bottom button
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Action Button
      bottomNavigationBar: isPending
          ? SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditReportScreen(report: report),
                ),
              );
            },
            icon: const Icon(Icons.check_circle_outline, size: 24),
            label: const Text(
              'Tandai Selesai',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
