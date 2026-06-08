import 'package:plantdoctor/l10n/app_localizations.dart';

class PlantCareTipModel {
  final String category;
  final String icon;
  final String Function(AppLocalizations) titleSelector;
  final String Function(AppLocalizations) descSelector;

  const PlantCareTipModel({
    required this.category,
    required this.icon,
    required this.titleSelector,
    required this.descSelector,
  });

  static List<PlantCareTipModel> getStaticTips() {
    return [
      PlantCareTipModel(
        category: 'watering',
        icon: '💧',
        titleSelector: (l10n) => l10n.tipWateringTitle,
        descSelector: (l10n) => l10n.tipWateringDesc,
      ),
      PlantCareTipModel(
        category: 'sunlight',
        icon: '☀️',
        titleSelector: (l10n) => l10n.tipSunlightTitle,
        descSelector: (l10n) => l10n.tipSunlightDesc,
      ),
      PlantCareTipModel(
        category: 'fertilization',
        icon: '🌱',
        titleSelector: (l10n) => l10n.tipFertilizationTitle,
        descSelector: (l10n) => l10n.tipFertilizationDesc,
      ),
      PlantCareTipModel(
        category: 'prevention',
        icon: '🛡️',
        titleSelector: (l10n) => l10n.tipPreventionTitle,
        descSelector: (l10n) => l10n.tipPreventionDesc,
      ),
      PlantCareTipModel(
        category: 'inspection',
        icon: '🔍',
        titleSelector: (l10n) => l10n.tipInspectionTitle,
        descSelector: (l10n) => l10n.tipInspectionDesc,
      ),
    ];
  }
}
