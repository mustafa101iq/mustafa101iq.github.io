import 'package:get/get.dart';
import 'package:portfolio_website/core/services/localization_service.dart';

class LocalizedField {
  const LocalizedField({required this.en, required this.ar});

  final String en;
  final String ar;

  String get text {
    final isArabic = Get.isRegistered<LocalizationService>()
        ? Get.find<LocalizationService>().isArabic
        : (Get.locale?.languageCode == 'ar');
    return isArabic ? (ar.isNotEmpty ? ar : en) : (en.isNotEmpty ? en : ar);
  }

  factory LocalizedField.fromJson(dynamic json, {String fallback = ''}) {
    if (json == null) return LocalizedField(en: fallback, ar: fallback);
    if (json is String) return LocalizedField(en: json, ar: json);
    if (json is Map) {
      final map = json.map((key, value) => MapEntry(key.toString(), value));
      return LocalizedField(
        en: (map['en'] as String?) ?? fallback,
        ar: (map['ar'] as String?) ?? (map['en'] as String?) ?? fallback,
      );
    }
    return LocalizedField(en: fallback, ar: fallback);
  }
}

class PortfolioData {
  const PortfolioData({
    required this.profile,
    required this.about,
    required this.skills,
    required this.services,
    required this.experience,
    required this.education,
  });

  final ProfileModel profile;
  final AboutModel about;
  final List<SkillModel> skills;
  final List<ServiceModel> services;
  final List<ExperienceModel> experience;
  final List<EducationModel> education;

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    return PortfolioData(
      profile: ProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
      about: AboutModel.fromJson(json['about'] as Map<String, dynamic>),
      skills: (json['skills'] as List<dynamic>)
          .map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      services: (json['services'] as List<dynamic>)
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      experience: (json['experience'] as List<dynamic>)
          .map((e) => ExperienceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      education: (json['education'] as List<dynamic>)
          .map((e) => EducationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProfileModel {
  const ProfileModel({
    required this.fullName,
    required this.jobTitle,
    required this.shortBio,
    required this.avatarUrl,
    required this.yearsOfExperience,
    required this.email,
    required this.phone,
    required this.location,
    required this.cvUrl,
    required this.social,
  });

  final LocalizedField fullName;
  final LocalizedField jobTitle;
  final LocalizedField shortBio;
  final String avatarUrl;
  final int yearsOfExperience;
  final String email;
  final String phone;
  final LocalizedField location;
  final String cvUrl;
  final SocialLinks social;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: LocalizedField.fromJson(json['fullName']),
      jobTitle: LocalizedField.fromJson(json['jobTitle']),
      shortBio: LocalizedField.fromJson(json['shortBio']),
      avatarUrl: json['avatarUrl'] as String? ?? '',
      yearsOfExperience: json['yearsOfExperience'] as int,
      email: json['email'] as String,
      phone: json['phone'] as String,
      location: LocalizedField.fromJson(json['location']),
      cvUrl: json['cvUrl'] as String,
      social: SocialLinks.fromJson(json['social'] as Map<String, dynamic>),
    );
  }
}

class SocialLinks {
  const SocialLinks({
    required this.github,
    required this.linkedin,
    required this.instagram,
    required this.whatsapp,
    required this.telegram,
    required this.email,
  });

  final String github;
  final String linkedin;
  final String instagram;
  final String whatsapp;
  final String telegram;
  final String email;

  factory SocialLinks.fromJson(Map<String, dynamic> json) {
    return SocialLinks(
      github: json['github'] as String? ?? '',
      linkedin: json['linkedin'] as String? ?? '',
      instagram: json['instagram'] as String? ?? '',
      whatsapp: json['whatsapp'] as String? ?? '',
      telegram: json['telegram'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}

class AboutModel {
  const AboutModel({
    required this.intro,
    required this.specialization,
    required this.strengths,
    required this.workStyle,
  });

  final LocalizedField intro;
  final LocalizedField specialization;
  final List<LocalizedField> strengths;
  final LocalizedField workStyle;

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(
      intro: LocalizedField.fromJson(json['intro']),
      specialization: LocalizedField.fromJson(json['specialization']),
      strengths: (json['strengths'] as List<dynamic>)
          .map(LocalizedField.fromJson)
          .toList(),
      workStyle: LocalizedField.fromJson(json['workStyle']),
    );
  }
}

class SkillModel {
  const SkillModel({
    required this.name,
    required this.level,
    required this.category,
  });

  final LocalizedField name;
  final double level;
  final LocalizedField category;

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      name: LocalizedField.fromJson(json['name']),
      level: (json['level'] as num).toDouble(),
      category: LocalizedField.fromJson(json['category'], fallback: 'Other'),
    );
  }
}

class ServiceModel {
  const ServiceModel({
    required this.title,
    required this.description,
    required this.icon,
  });

  final LocalizedField title;
  final LocalizedField description;
  final String icon;

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      title: LocalizedField.fromJson(json['title']),
      description: LocalizedField.fromJson(json['description']),
      icon: json['icon'] as String,
    );
  }
}

class ExperienceModel {
  const ExperienceModel({
    required this.role,
    required this.company,
    required this.period,
    required this.description,
  });

  final LocalizedField role;
  final LocalizedField company;
  final LocalizedField period;
  final LocalizedField description;

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      role: LocalizedField.fromJson(json['role']),
      company: LocalizedField.fromJson(json['company']),
      period: LocalizedField.fromJson(json['period']),
      description: LocalizedField.fromJson(json['description']),
    );
  }
}

class EducationModel {
  const EducationModel({
    required this.degree,
    required this.institution,
    required this.period,
    required this.description,
  });

  final LocalizedField degree;
  final LocalizedField institution;
  final LocalizedField period;
  final LocalizedField description;

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      degree: LocalizedField.fromJson(json['degree']),
      institution: LocalizedField.fromJson(json['institution']),
      period: LocalizedField.fromJson(json['period']),
      description: LocalizedField.fromJson(json['description']),
    );
  }
}
