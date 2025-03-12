import 'dart:convert';
import 'package:flutter/material.dart';
import '../../_services/reportService.dart';
import 'addReportPage.dart';
import 'package:flareline/pages/layout.dart';

class ReportPage extends LayoutWidget {
  const ReportPage({super.key});


  @override
  Widget contentDesktopWidget(BuildContext context) => const _ReportPageContent();

  @override
  Widget contentMobileWidget(BuildContext context) => const _ReportPageContent();
}

class _ReportPageContent extends StatefulWidget {
  const _ReportPageContent();

  @override
  _ReportPageContentState createState() => _ReportPageContentState();
}

class _ReportPageContentState extends State<_ReportPageContent> {
  List<dynamic> reports = [];
  bool isLoading = true;
  String? errorMessage;
  String filterStatus = 'All';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      List<dynamic> data = await ReportService.getReports();
      print("Data fetched: ${jsonEncode(data)}");
      if (mounted) {
        setState(() {
          reports = data ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching reports: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load reports: $e';
        });
      }
    }
  }

  List<dynamic> getFilteredReports() {
    var filtered = reports;
    if (filterStatus != 'All') {
      filtered = filtered.where((report) => report['reportStatus'] == filterStatus).toList();
    }
    if (searchController.text.isNotEmpty) {
      filtered = filtered
          .where((report) =>
      report['reportContent']?.toString().toLowerCase().contains(searchController.text.toLowerCase()) ?? false)
          .toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 24),
                _buildFilterSection(),
                const SizedBox(height: 24),
                _buildStatsSection(),
                const SizedBox(height: 24),
                _buildReportsTable(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddReportPage()),
            ).then((_) => fetchReports());
          },
          backgroundColor: const Color(0xFF109FDB),
          elevation: 6,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
          tooltip: 'Add New Report',
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF109FDB), Color(0xFF66C8F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Reports Dashboard',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            children: [
              if (errorMessage != null)
                IconButton(
                  icon: const Icon(Icons.replay, color: Colors.white, size: 24),
                  onPressed: fetchReports,
                  tooltip: 'Retry',
                ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white, size: 24),
                onPressed: fetchReports,
                tooltip: 'Refresh',
              ),
              const SizedBox(width: 12),
              Chip(
                label: Text('${reports.length} Reports', style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                backgroundColor: Colors.white.withOpacity(0.2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search reports...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 16),
          DropdownButton<String>(
            value: filterStatus,
            items: ['All', 'Pending', 'Approved', 'Rejected']
                .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                .toList(),
            onChanged: (value) => setState(() => filterStatus = value!),
            underline: const SizedBox(),
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            dropdownColor: Colors.white,
            icon: const Icon(Icons.filter_list, color: Color(0xFF109FDB)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final filteredReports = getFilteredReports();
    final pending = filteredReports.where((r) => r['reportStatus'] == 'Pending').length;
    final approved = filteredReports.where((r) => r['reportStatus'] == 'Approved').length;
    final rejected = filteredReports.where((r) => r['reportStatus'] == 'Rejected').length;

    return Row(
      children: [
        _buildStatCard('Pending', pending, Colors.orange.shade700),
        const SizedBox(width: 16),
        _buildStatCard('Approved', approved, Colors.green.shade700),
        const SizedBox(width: 16),
        _buildStatCard('Rejected', rejected, Colors.red.shade700),
      ],
    );
  }

  Widget _buildStatCard(String title, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsTable() {
    final filteredReports = getFilteredReports();

    if (isLoading) {
      return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xFF109FDB))));
    } else if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!, style: TextStyle(color: Colors.red.shade700, fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchReports,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF109FDB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else if (filteredReports.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              filterStatus == 'All' ? 'No reports available. Create your first report!' : 'No $filterStatus reports found.',
              style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic, fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (filterStatus == 'All')
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddReportPage())).then((_) => fetchReports());
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF109FDB)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Add Now', style: TextStyle(color: Color(0xFF109FDB))),
              ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 24,
          headingRowHeight: 56,
          dataRowHeight: 60,
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
          dataRowColor: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.hovered) ? Colors.grey.shade50 : Colors.white),
          border: TableBorder.all(color: Colors.grey.shade200, width: 1),
          columns: const [
            DataColumn(label: Text('Report ID', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('User ID', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Content', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Created At', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Last Updated', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: filteredReports.map((report) => _buildDataRow(report)).toList(),
        ),
      ),
    );
  }

  DataRow _buildDataRow(dynamic report) {
    return DataRow(
      cells: [
        DataCell(Text(report['reportId'].toString())),
        DataCell(Text(report['userId'].toString())),
        DataCell(
          SizedBox(
            width: 200,
            child: Text(
              report['reportContent'] ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        DataCell(Text(report['createdAt']?.toString().split('.')[0] ?? '')),
        DataCell(Text(report['lastUpdatedAt']?.toString().split('.')[0] ?? 'Not updated')),
        DataCell(
          Chip(
            label: Text(report['reportStatus'] ?? 'Pending'),
            backgroundColor: _getStatusColor(report['reportStatus']).withOpacity(0.1),
            labelStyle: TextStyle(color: _getStatusColor(report['reportStatus'])),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit not implemented yet'))),
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Report'),
                      content: const Text('Are you sure you want to delete this report?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    try {
                      await ReportService.deleteReport(report['reportId'].toString());
                      setState(() {
                        reports.removeWhere((r) => r['reportId'] == report['reportId']);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report deleted')));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
                    }
                  }
                },
                tooltip: 'Delete',
              ),
            ],
          ),
        ),
      ],
      onSelectChanged: (selected) {
        if (selected ?? false) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected: ${report['reportContent'] ?? ''}')));
        }
      },
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Approved':
        return Colors.green.shade700;
      case 'Rejected':
        return Colors.red.shade700;
      case 'Pending':
      default:
        return Colors.orange.shade700;
    }
  }
}