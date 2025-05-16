class ChartData {
  final DateTime time;
  final double value;

  ChartData({required this.time, required this.value});

  factory ChartData.fromJson(Map<String, dynamic> json, String fieldName) {
    // Gestione più robusta dei valori nulli o non validi
    try {
      final timeStr = json['created_at'];
      final valueStr = json[fieldName];

      if (timeStr == null || valueStr == null || valueStr == '') {
        throw FormatException('Invalid data: time=$timeStr, value=$valueStr');
      }

      
      double parsedValue;
      try {
        parsedValue = double.parse(valueStr.toString());
      } catch (e) {
        print('Error parsing value "$valueStr" to double: $e');
        parsedValue = 0.0;
      }

      return ChartData(
        time: DateTime.parse(timeStr),
        value: parsedValue,
      );
    } catch (e) {
      print('Error parsing ChartData: $e');
      // Valore predefinito in caso di errore
      return ChartData(
        time: DateTime.now(),
        value: 0,
      );
    }
  }
}

class ThingSpeakFeed {
  final List<Map<String, dynamic>> feeds;
  final Map<String, dynamic> channel;

  ThingSpeakFeed({required this.feeds, required this.channel});

  factory ThingSpeakFeed.fromJson(Map<String, dynamic> json) {
    try {
      List<Map<String, dynamic>> feedsList = [];
      if (json['feeds'] != null) {
        if (json['feeds'] is List) {
          feedsList = List<Map<String, dynamic>>.from(json['feeds']);
        } else {
          print('Feeds is not a list: ${json['feeds']}');
        }
      }

      return ThingSpeakFeed(
        feeds: feedsList,
        channel: json['channel'] ?? {},
      );
    } catch (e) {
      print('Error parsing ThingSpeakFeed: $e');
      return ThingSpeakFeed(feeds: [], channel: {});
    }
  }
}