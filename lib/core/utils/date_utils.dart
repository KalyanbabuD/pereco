class AppDateUtils {
  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  static DateTime? parseApiDate(String? apiDateString) {
    if (apiDateString == null || apiDateString.isEmpty) return null;
    try {
      DateTime dt = DateTime.parse(apiDateString).toLocal();
      print('--- AppDateUtils.parseApiDate ---');
      print('Raw API String: $apiDateString');
      print('Parsed Local DateTime: $dt');
      return dt;
    } catch (e) {
      print('Error parsing date $apiDateString: $e');
      return null;
    }
  }

  static String formatForApi(DateTime dateTime) {
    String formatted = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:00';
    print('--- AppDateUtils.formatForApi ---');
    print('Input Local DateTime: $dateTime');
    print('Formatted String for API: $formatted');
    return formatted;
  }

  static String formatDateForUI(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')} ${_months[dateTime.month - 1]} ${dateTime.year}';
  }

  static String formatDateTimeForUI(DateTime dateTime) {
    int hour12 = dateTime.hour % 12;
    hour12 = hour12 == 0 ? 12 : hour12;
    String amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${formatDateForUI(dateTime)}, ${hour12.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $amPm';
  }
}
