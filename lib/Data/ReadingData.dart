class ReadingData {
  final String day;
  final int minutes;

  ReadingData({required this.day, required this.minutes});

  factory ReadingData.fromFirestore(Map<String, dynamic> data){
    return ReadingData(day: data['day'], minutes: data['minutes']);
  }
}