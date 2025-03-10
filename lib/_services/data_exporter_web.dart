import 'dart:html' as html;

void exportToCsvWeb(String csv, String fileName) {
  final blob = html.Blob([csv]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();
  html.Url.revokeObjectUrl(url);
}