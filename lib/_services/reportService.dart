import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportService {
  static const String baseUrl = 'http://192.168.1.6:5000/api/v1/reports'; // Fixed typo

  // Get all reports
  static Future<List<dynamic>> getReports() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      print('GET $baseUrl - Status: ${response.statusCode}, Body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load reports: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in getReports: $e'); // Log error
      rethrow; // Preserve stack trace
    }
  }

  // Get report by ID
  static Future<Map<String, dynamic>> getReportById(String reportId) async {
    try {
      final url = '$baseUrl/$reportId';
      final response = await http.get(Uri.parse(url));
      print('GET $url - Status: ${response.statusCode}, Body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        throw Exception('Report not found: $reportId');
      } else {
        throw Exception('Failed to fetch report: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in getReportById: $e'); // Log error
      rethrow;
    }
  }

  // Create a new report
  static Future<Map<String, dynamic>> createReport(Map<String, dynamic> reportData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reportData),
      );
      print('POST $baseUrl - Status: ${response.statusCode}, Body: ${response.body}'); // Debug log

      if (response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to create report: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in createReport: $e'); // Log error
      rethrow;
    }
  }

  // Update a report
  static Future<Map<String, dynamic>> updateReport(String reportId, Map<String, dynamic> reportData) async {
    try {
      final url = '$baseUrl/$reportId';
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reportData),
      );
      print('PUT $url - Status: ${response.statusCode}, Body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        throw Exception('Report not found: $reportId');
      } else {
        throw Exception('Failed to update report: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in updateReport: $e'); // Log error
      rethrow;
    }
  }

  // Delete a report
  static Future<bool> deleteReport(String reportId) async {
    try {
      final url = '$baseUrl/$reportId';
      final response = await http.delete(Uri.parse(url));
      print('DELETE $url - Status: ${response.statusCode}, Body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Report not found: $reportId');
      } else {
        throw Exception('Failed to delete report: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in deleteReport: $e'); // Log error
      rethrow;
    }
  }
}