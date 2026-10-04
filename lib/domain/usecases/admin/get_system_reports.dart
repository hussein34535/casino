class GetSystemReports {
  Future<Map<String, dynamic>> call() async {
    return {
      'serverStatus': 'healthy',
      'databaseSize': '0 MB',
      'activeConnections': 0,
      'averageResponseTime': '0ms',
      'uptime': '0h',
      'lastBackup': null,
    };
  }
}
