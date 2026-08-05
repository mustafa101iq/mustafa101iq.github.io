import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:portfolio_website/modules/home/models/portfolio_models.dart';
import 'package:portfolio_website/modules/home/models/project_model.dart';

class PortfolioBootstrap {
  PortfolioBootstrap._();

  static PortfolioData? portfolio;
  static List<ProjectModel> projects = const [];

  static Future<void> load() async {
    final results = await Future.wait([
      rootBundle.loadString('assets/data/portfolio.json'),
      rootBundle.loadString('assets/data/projects.json'),
    ]);
    portfolio = PortfolioData.fromJson(
      jsonDecode(results[0]) as Map<String, dynamic>,
    );
    projects = (jsonDecode(results[1]) as List<dynamic>)
        .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
