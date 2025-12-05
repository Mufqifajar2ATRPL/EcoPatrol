class ReportModel {
  final int? id;
  final String title;
  final String description;
  final String photoPath;
  final double latitude;
  final double longitude;
  final String status; // 'pending' atau 'completed'
  final String? completionDescription;
  final String? completionPhotoPath;
  final DateTime createdAt;

  ReportModel({
    this.id,
    required this.title,
    required this.description,
    required this.photoPath,
    required this.latitude,
    required this.longitude,
    this.status = 'pending',
    this.completionDescription,
    this.completionPhotoPath,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'photoPath': photoPath,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'completionDescription': completionDescription,
      'completionPhotoPath': completionPhotoPath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      photoPath: map['photoPath'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      status: map['status'],
      completionDescription: map['completionDescription'],
      completionPhotoPath: map['completionPhotoPath'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}