import 'package:equatable/equatable.dart';

class ScanHistory extends Equatable {
  final dynamic id; // Key from Hive box
  final String plantName;
  final String diseaseName;
  final String imagePath;
  final double confidence;
  final DateTime scanDate;
  final bool isHealthy;

  const ScanHistory({
    this.id,
    required this.plantName,
    required this.diseaseName,
    required this.imagePath,
    required this.confidence,
    required this.scanDate,
    required this.isHealthy,
  });

  @override
  List<Object?> get props => [
        id,
        plantName,
        diseaseName,
        imagePath,
        confidence,
        scanDate,
        isHealthy,
      ];
}
