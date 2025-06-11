import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medsync/presentation/common/widgets/loading_indicator.dart';
import 'package:medsync/presentation/features/admin/viewmodels/admin_dashboard_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardView extends ConsumerWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(adminDashboardViewModelProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Admin Dashboard',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          dashboardState.dashboardStats.when(
            data: (stats) {
              return GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCard(
                    context,
                    Icons.people,
                    'Total Patient',
                    stats['patients']?.toString() ?? '0',
                  ),
                  _buildStatCard(
                    context,
                    Icons.local_hospital,
                    'Total Doctors',
                    stats['doctors']?.toString() ?? '0',
                  ),
                  _buildStatCard(
                    context,
                    Icons.calendar_today,
                    'Total Appointment',
                    stats['appointments']?.toString() ?? '0',
                  ),
                  _buildStatCard(
                    context,
                    Icons.personal_injury,
                    'Total Triage',
                    stats['triageStaff']?.toString() ?? '0',
                  ),
                ],
              );
            },
            loading: () => const LoadingIndicator(),
            error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
          ),
          const SizedBox(height: 30),
          Text(
            'Patients Activity',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d), width: 1),
                ),
                minX: 0,
                maxX: 7,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 3),
                      FlSpot(1, 2),
                      FlSpot(2, 5),
                      FlSpot(3, 3),
                      FlSpot(4, 4),
                      FlSpot(5, 3),
                      FlSpot(6, 4),
                    ],
                    isCurved: true,
                    color: Theme.of(context).colorScheme.primary,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          // The rest of the content (Upcoming Appointments, Recent Patients, Doctor Staff, Triage Staff) will be removed
          // as the screenshot only shows the four main stats and a chart.
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
