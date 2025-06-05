import 'package:http/http.dart' as http;

class ESP32Service {
  static const String esp32Ip = "192.168.1.5"; // Update this with your actual ESP32 IP

  static Future<void> sendSchedule(String name, String dosage, String time) async {
    final url = Uri.parse('http://$esp32Ip/setSchedule');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "name": name,
          "dosage": dosage,
          "time": time,
        },
      );

      if (response.statusCode == 200) {
        print("✅ Schedule sent successfully: $time");
      } else {
        print("❌ Failed to send schedule: ${response.statusCode}");
        print("📌 Response: ${response.body}");
      }
    } catch (e) {
      print("❌ Error sending schedule: ${e.toString()}");
    }
  }
}
