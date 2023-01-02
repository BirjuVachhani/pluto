import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../home/background_store.dart';
import '../model/unsplash_collection.dart';
import '../resources/colors.dart';
import '../ui/text_input.dart';

class NewCollectionDialog extends StatefulWidget {
  final BackgroundStore store;

  const NewCollectionDialog({super.key, required this.store});

  @override
  State<NewCollectionDialog> createState() => _NewCollectionDialogState();
}

class _NewCollectionDialogState extends State<NewCollectionDialog> {
  final TextEditingController _controller = TextEditingController();

  final StreamController<String> _textStreamController =
      StreamController<String>();

  bool? isValid;

  @override
  void initState() {
    super.initState();
    _textStreamController.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen(onTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: min(450, MediaQuery.of(context).size.width * 0.9),
          // height: min(500, MediaQuery.of(context).size.height * 0.9),
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
          decoration: BoxDecoration(
            color: AppColors.settingsPanelBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon(
                    //   Icons.collections_rounded,
                    //   size: 72,
                    //   color: Colors.grey.shade700,
                    // ),
                    // const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'New Collection',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Enter keywords/tags of the topic you want to see '
                            'in the backgrounds. e.g. snow, mountains, etc.',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          // const SizedBox(height: 8),
                          // const Text(
                          //   'Enter your keywords',
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     height: 1.4,
                          //     fontWeight: FontWeight.w300,
                          //     color: Colors.grey,
                          //   ),
                          // ),
                          const SizedBox(height: 24),
                          TextInput(
                            controller: _controller,
                            hintText: 'Keywords',
                            onChanged: (value) {
                              if (isValid != null || value.trim().isEmpty) {
                                setState(() => isValid = null);
                              }
                              _textStreamController.add(value);
                            },
                            hintStyle: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2,
                            ),
                            suffixIcon:
                                ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _controller,
                              builder: (context, value, child) {
                                if (value.text.trim().isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                if (isValid == null) {
                                  return const CupertinoActivityIndicator(
                                    radius: 8,
                                    animating: true,
                                  );
                                }

                                return Icon(
                                  isValid!
                                      ? Icons.done_rounded
                                      : Icons.info_outline_rounded,
                                  color: isValid!
                                      ? Colors.greenAccent
                                      : Colors.red,
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4, top: 4),
                            child: AnimatedSize(
                              // opacity: true || isValid == false ? 1 : 0,
                              duration: const Duration(milliseconds: 250),
                              alignment: Alignment.centerLeft,
                              curve: Curves.easeInOut,
                              child: isValid == false
                                  ? const Text(
                                      'No images available!',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 0.2,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade900,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: isValid == true
                          ? () =>
                              Navigator.pop(context, _controller.text.trim())
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Create'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// This indirectly checks if the unsplash URL with the given keywords
  /// returns a 404 image URL or not. While this might not be the best way to
  /// check if the collection is valid or not, it is the only way I could find
  /// to do so with the Unsplash source API.
  Future<void> onTextChanged(String value) async {
    value = value.trim();
    if (mounted) setState(() => isValid = null);
    try {
      final source = UnsplashTagsSource(tags: value);
      final String url = widget.store.buildUnsplashImageURL(source);
      final String? redirectionUrl =
          await widget.store.retrieveRedirectionUrl(url);
      if (redirectionUrl != null && redirectionUrl.contains('source-404')) {
        isValid = false;
      } else {
        final http.Response response =
            await http.get(Uri.parse(redirectionUrl ?? url));
        isValid = response.statusCode != 302;
      }
    } catch (error, stacktrace) {
      log(error.toString());
      log(stacktrace.toString());
      isValid = false;
    } finally {
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _textStreamController.close();
    super.dispose();
  }
}
