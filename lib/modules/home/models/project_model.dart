import 'package:portfolio_website/modules/home/models/portfolio_models.dart';

class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.images,
    required this.visualStyle,
    required this.technologies,
    required this.liveDemoUrl,
    required this.githubUrl,
    required this.details,
  });

  final String id;
  final LocalizedField title;
  final LocalizedField description;
  final String imageUrl;
  final List<String> images;
  final String visualStyle;
  final List<LocalizedField> technologies;
  final String liveDemoUrl;
  final String githubUrl;
  final LocalizedField details;

  bool get isCoverVisual => visualStyle == 'cover';

  List<String> get previewImages {
    if (images.isNotEmpty) return images;
    if (imageUrl.isNotEmpty) return [imageUrl];
    return const [];
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final imageUrl = json['imageUrl'] as String? ?? '';
    final images = (json['images'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .where((e) => e.isNotEmpty)
            .toList() ??
        (imageUrl.isNotEmpty ? [imageUrl] : <String>[]);

    return ProjectModel(
      id: json['id'] as String,
      title: LocalizedField.fromJson(json['title']),
      description: LocalizedField.fromJson(json['description']),
      imageUrl: imageUrl,
      images: images,
      visualStyle: json['visualStyle'] as String? ?? 'device',
      technologies: (json['technologies'] as List<dynamic>)
          .map(LocalizedField.fromJson)
          .toList(),
      liveDemoUrl: json['liveDemoUrl'] as String? ?? '',
      githubUrl: json['githubUrl'] as String? ?? '',
      details: LocalizedField.fromJson(json['details']),
    );
  }
}
