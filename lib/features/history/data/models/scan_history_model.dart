import 'package:hive/hive.dart';
import '../../domain/entities/scan_history.dart';

part 'scan_history_model.g.dart';

@HiveType(typeId: 0)
class ScanHistoryModel extends HiveObject {
  @HiveField(0)
  final String plantName;

  @HiveField(1)
  final String diseaseName;

  @HiveField(2)
  final String imagePath;

  @HiveField(3)
  final double confidence;

  @HiveField(4)
  final DateTime scanDate;

  @HiveField(5)
  final bool isHealthy;

  ScanHistoryModel({
    required this.plantName,
    required this.diseaseName,
    required this.imagePath,
    required this.confidence,
    required this.scanDate,
    required this.isHealthy,
  });

  ScanHistory toEntity() {
    return ScanHistory(
      id: key, // Hive key can be used as id (it's dynamic, usually int)
      plantName: plantName,
      diseaseName: diseaseName,
      imagePath: imagePath,
      confidence: confidence,
      scanDate: scanDate,
      isHealthy: isHealthy,
    );
  }

  factory ScanHistoryModel.fromEntity(ScanHistory entity) {
    return ScanHistoryModel(
      plantName: entity.plantName,
      diseaseName: entity.diseaseName,
      imagePath: entity.imagePath,
      confidence: entity.confidence,
      scanDate: entity.scanDate,
      isHealthy: entity.isHealthy,
    );
  }
}
