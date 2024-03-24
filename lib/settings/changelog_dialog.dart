import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../resources/colors.dart';
import '../ui/gesture_detector_with_cursor.dart';

class ChangelogDialog extends StatefulWidget {
  const ChangelogDialog({super.key});

  @override
  State<ChangelogDialog> createState() => _ChangelogDialogState();
}

class _ChangelogDialogState extends State<ChangelogDialog> {
  String? changelog;
  String? version;
  DateTime? date;
  String? error;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChangelog();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: min(620, MediaQuery.of(context).size.width * 0.9),
        height: min(500, MediaQuery.of(context).size.height * 0.9),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.settingsPanelBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "What's new in Pluto",
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ),
                  Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      splashRadius: 16,
                      iconSize: 18,
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CupertinoActivityIndicator(
                    radius: 12,
                  ),
                ),
              ),
            if (error != null)
              Expanded(
                child: Center(
                  child: Text(
                    error!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            if (changelog != null) ...[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.dropdownOverlayColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        color: Theme.of(context).colorScheme.primary,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'v$version',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 2),
                              ),
                            ),
                            Text(
                              DateFormat('dd MMMM, yyyy').format(date!),
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 20),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                textTheme: Theme.of(context).textTheme.copyWith(
                                      bodyMedium: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          ),
                                    ),
                              ),
                              child: MarkdownBody(
                                data: changelog!,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: GestureDetectorWithCursor(
                  onTap: () => launchUrl(Uri.parse(
                      'https://github.com/BirjuVachhani/pluto/blob/main/CHANGELOG.md')),
                  child: Hoverable(
                    builder: (context, hovering, child) => Text(
                      'View All Changelogs',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        decoration: hovering ? TextDecoration.underline : null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> fetchChangelog() async {
    isLoading = true;
    if (mounted) setState(() {});
    try {
      version = packageInfo.version;
      final response = await http.get(Uri.parse(
          'https://raw.githubusercontent.com/BirjuVachhani/pluto/$version/CHANGELOG.md'));

      final releaseResponse = await http.get(Uri.parse(
          'https://api.github.com/repos/BirjuVachhani/pluto/releases/tags/$version'));
      isLoading = false;
      if (response.statusCode != 200 || releaseResponse.statusCode != 200) {
        throw Exception(response.body);
      }
      changelog = response.body;
      final jsonData = json.decode(releaseResponse.body);
      date = DateTime.tryParse(jsonData['published_at']);
      changelog = jsonData['body']?.toString();
      if (mounted) setState(() {});
    } catch (err, stacktrace) {
      log(err.toString());
      log(stacktrace.toString());
      isLoading = false;
      error = 'Unable to load changelog. Please try again later.';
      if (mounted) setState(() {});
    }
  }
}
