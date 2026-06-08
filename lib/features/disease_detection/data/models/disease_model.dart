/// Represents one description paragraph returned by the API.
class DiseaseDescriptionModel {
  final String? subtitle;
  final String? description;

  const DiseaseDescriptionModel({this.subtitle, this.description});

  factory DiseaseDescriptionModel.fromJson(Map<String, dynamic> json) {
    return DiseaseDescriptionModel(
      subtitle: json['subtitle'] as String?,
      description: json['description'] as String?,
    );
  }
}

/// Represents one solution/treatment section.
class DiseaseSolutionModel {
  final String? subtitle;
  final String? description;

  const DiseaseSolutionModel({this.subtitle, this.description});

  factory DiseaseSolutionModel.fromJson(Map<String, dynamic> json) {
    return DiseaseSolutionModel(
      subtitle: json['subtitle'] as String?,
      description: json['description'] as String?,
    );
  }
}

/// Represents one image with multiple size variants.
class DiseaseImageModel {
  final String? thumbnail;
  final String? smallUrl;
  final String? mediumUrl;
  final String? regularUrl;
  final String? originalUrl;
  final String? licenseName;

  const DiseaseImageModel({
    this.thumbnail,
    this.smallUrl,
    this.mediumUrl,
    this.regularUrl,
    this.originalUrl,
    this.licenseName,
  });

  factory DiseaseImageModel.fromJson(Map<String, dynamic> json) {
    return DiseaseImageModel(
      thumbnail: json['thumbnail'] as String?,
      smallUrl: json['small_url'] as String?,
      mediumUrl: json['medium_url'] as String?,
      regularUrl: json['regular_url'] as String?,
      originalUrl: json['original_url'] as String?,
      licenseName: json['license_name'] as String?,
    );
  }

  /// Returns the best available URL in descending quality order.
  String? get bestUrl =>
      regularUrl ?? mediumUrl ?? smallUrl ?? thumbnail ?? originalUrl;
}

/// Main disease model — maps directly to one item in the API `data` array.
class DiseaseModel {
  final int id;
  final String commonName;
  final String scientificName;
  final List<String> otherNames;
  final List<DiseaseDescriptionModel> descriptions;
  final List<DiseaseSolutionModel> solutions;
  final List<String> hosts;
  final List<DiseaseImageModel> images;

  const DiseaseModel({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.otherNames,
    required this.descriptions,
    required this.solutions,
    required this.hosts,
    required this.images,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    // other_name can be null or a List
    List<String> parseOtherNames(dynamic raw) {
      if (raw == null) return [];
      if (raw is List) return raw.map((e) => e.toString()).toList();
      return [];
    }

    return DiseaseModel(
      id: (json['id'] as num).toInt(),
      commonName: (json['common_name'] as String?)?.trim() ?? 'Unknown',
      scientificName: (json['scientific_name'] as String?)?.trim() ?? '',
      otherNames: parseOtherNames(json['other_name']),
      descriptions: (json['description'] as List<dynamic>?)
              ?.map((e) => DiseaseDescriptionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      solutions: (json['solution'] as List<dynamic>?)
              ?.map((e) => DiseaseSolutionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      hosts: (json['host'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => DiseaseImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convenience: first thumbnail URL from images list.
  String? get thumbnailUrl => images.isNotEmpty ? images.first.thumbnail : null;

  /// Convenience: best quality URL of the first image.
  String? get firstImageUrl => images.isNotEmpty ? images.first.bestUrl : null;

  /// Convenience: first description text.
  String? get firstDescription =>
      descriptions.isNotEmpty ? descriptions.first.description : null;
}

/// Wrapper for the paginated API response.
class DiseaseListResponse {
  final List<DiseaseModel> diseases;
  final int? currentPage;
  final int? lastPage;
  final int? total;

  const DiseaseListResponse({
    required this.diseases,
    this.currentPage,
    this.lastPage,
    this.total,
  });

  factory DiseaseListResponse.fromJson(Map<String, dynamic> json) {
    return DiseaseListResponse(
      diseases: (json['data'] as List<dynamic>?)
              ?.map((e) => DiseaseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      total: json['total'] as int?,
    );
  }

  bool get hasMorePages =>
      currentPage != null && lastPage != null && currentPage! < lastPage!;
}
