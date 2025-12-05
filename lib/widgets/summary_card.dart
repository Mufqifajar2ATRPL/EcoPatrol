import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final int totalReports;
  final int completedReports;
  final int pendingReports;

  const SummaryCard({
    Key? key,
    required this.totalReports,
    required this.completedReports,
    required this.pendingReports,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assessment, color: Colors.green[700], size: 28),
                const SizedBox(width: 10),
                const Text(
                  'Ringkasan Laporan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  icon: Icons.list_alt,
                  label: 'Total',
                  value: totalReports.toString(),
                  color: Colors.blue,
                ),
                _buildSummaryItem(
                  icon: Icons.check_circle,
                  label: 'Selesai',
                  value: completedReports.toString(),
                  color: Colors.green,
                ),
                _buildSummaryItem(
                  icon: Icons.pending,
                  label: 'Pending',
                  value: pendingReports.toString(),
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}