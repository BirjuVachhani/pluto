import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/home_widget.dart';
import '../../model/widget_settings.dart';
import '../../resources/fonts.dart';
import '../../ui/alignment_control.dart';
import '../../ui/custom_dropdown.dart';
import '../../ui/custom_slider.dart';
import '../../ui/text_input.dart';
import '../../utils/utils.dart';

class WeatherWidgetSettingsView extends StatelessWidget {
  const WeatherWidgetSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WidgetModelBase>(
      builder: (context, model, child) {
        final settings = model.weatherSettings;
        return Column(
          children: [
            const SizedBox(height: 16),
            CustomDropdown<String>(
              label: 'Font',
              isExpanded: true,
              value: settings.fontFamily,
              items: FontFamilies.fonts,
              onSelected: (family) => model.updateWeatherSettings(
                settings.copyWith(fontFamily: family),
              ),
            ),
            const SizedBox(height: 16),
            CustomSlider(
              label: 'Font size',
              min: 10,
              max: 400,
              valueLabel: '${settings.fontSize.floor().toString()} px',
              value: settings.fontSize,
              onChanged: (value) => model.updateWeatherSettings(
                settings.copyWith(fontSize: value.floorToDouble()),
              ),
            ),
            const SizedBox(height: 16),
            AlignmentControl(
              label: 'Position',
              alignment: settings.alignment,
              onChanged: (alignment) => model.updateWeatherSettings(
                settings.copyWith(alignment: alignment),
              ),
            ),
            const SizedBox(height: 16),
            CustomDropdown<WeatherFormat>(
              label: 'Format',
              isExpanded: true,
              value: settings.format,
              items: WeatherFormat.values,
              itemBuilder: (context, item) => Text(item.label),
              onSelected: (format) => model.updateWeatherSettings(
                settings.copyWith(format: format),
              ),
            ),
            const SizedBox(height: 16),
            LocationAutoCompleteField(
              key: ValueKey(settings.location),
              label: 'Location',
              location: settings.location,
              onChanged: (location) {
                if (location.latitude == settings.location.latitude &&
                    location.longitude == settings.location.longitude) {
                  return;
                }
                model.updateWeatherSettings(
                    settings.copyWith(location: location));
              },
            ),
            const SizedBox(height: 16),
            CustomDropdown<TemperatureUnit>(
              label: 'Temperature unit',
              isExpanded: true,
              value: settings.temperatureUnit,
              items: TemperatureUnit.values,
              itemBuilder: (context, item) => Text(item.label),
              onSelected: (unit) => model.updateWeatherSettings(
                settings.copyWith(temperatureUnit: unit),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class LocationAutoCompleteField extends StatefulWidget {
  final String label;
  final Location location;
  final ValueChanged<Location> onChanged;

  const LocationAutoCompleteField({
    super.key,
    required this.label,
    required this.location,
    required this.onChanged,
  });

  @override
  State<LocationAutoCompleteField> createState() =>
      _LocationAutoCompleteFieldState();
}

class _LocationAutoCompleteFieldState extends State<LocationAutoCompleteField> {
  late final AsyncDeBouncer _deBouncer =
      AsyncDeBouncer(const Duration(milliseconds: 500));

  ValueNotifier<bool> loadingNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.label),
        const SizedBox(height: 10),
        Autocomplete<Location>(
          initialValue: TextEditingValue(text: widget.location.name),
          optionsMaxHeight: 180,
          onSelected: (item) {
            // log('onSelected: $item');
            _deBouncer.cancel();
            if (item is _EmptyLocation) return;
            widget.onChanged(item);
          },
          optionsBuilder: (textEditingValue) async {
            if (textEditingValue.text.isEmpty) {
              _deBouncer.cancel();
              loadingNotifier.value = false;
              return [
                _EmptyLocation(
                  name: 'no_items',
                  latitude: widget.location.latitude,
                  longitude: widget.location.longitude,
                )
              ];
            }
            loadingNotifier.value = true;
            return _deBouncer.run<List<Location>>(() async {
              log('optionsBuilder: ${textEditingValue.text}');
              await Future.delayed(const Duration(seconds: 2));
              final results = testCities.where((location) {
                return location.name
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              }).toList();
              if (mounted) loadingNotifier.value = false;
              return results;
            });
          },
          fieldViewBuilder: (
            context,
            textEditingController,
            focusNode,
            onFieldSubmitted,
          ) {
            return TextInput(
              controller: textEditingController,
              focusNode: focusNode,
              fillColor: Colors.grey.withOpacity(0.15),
              showInitialBorder: false,
              suffixIcon: ValueListenableBuilder<bool>(
                valueListenable: loadingNotifier,
                builder: (context, loading, child) {
                  return loading && focusNode.hasFocus
                      ? Align(
                          alignment: Alignment.center,
                          widthFactor: 1,
                          child: CupertinoActivityIndicator(
                            radius: 8,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
              onSubmitted: (value) {
                onFieldSubmitted();
                if (value.trim().isEmpty) {
                  textEditingController.text = widget.location.name;
                }
                return true;
              },
              onFocusLost: () {
                _deBouncer.cancel();
                if (textEditingController.text != widget.location.name) {
                  textEditingController.text = widget.location.name;
                }
              },
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  constraints:
                      const BoxConstraints(maxHeight: 200, maxWidth: 310),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: ListView.builder(
                      itemCount: options.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final bool isEmpty = index == 0 &&
                            options.length == 1 &&
                            options.first is _EmptyLocation;
                        final location = options.elementAt(index);
                        final selected =
                            AutocompleteHighlightedOption.of(context) == index;
                        if (isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Align(
                              alignment: Alignment.center,
                              heightFactor: 1,
                              child: Text(
                                'No Options',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          );
                        }

                        return Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            onTap: () {
                              onSelected(location);
                            },
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(0.15)),
                            child: Container(
                              color: selected
                                  ? Colors.grey.shade300
                                  : Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Text(
                                location.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    loadingNotifier.dispose();
    super.dispose();
  }
}

typedef AsyncDeBounceAction<T> = Future<T> Function();

class AsyncDeBouncer {
  /// de-bounce period
  final Duration duration;

  Timer? _timer;

  Completer? _completer;

  /// Allows to create an instance with optional [Duration]
  AsyncDeBouncer([Duration? duration])
      : duration = duration ?? const Duration(milliseconds: 300);

  /// Runs [action] after debounced interval.
  Future<T> run<T>(AsyncDeBounceAction<T> action) {
    _completer ??= Completer<T>();
    _timer?.cancel();
    _timer = Timer(duration, () {
      action().then((value) {
        _completer?.complete(value);
        _completer = null;
      });
    });
    return (_completer as Completer<T>).future;
  }

  /// alias for [run]
  Future<T> call<T>(AsyncDeBounceAction<T> action) => run.call(action);

  /// Allows to cancel current timer.
  void cancel() {
    _timer?.cancel();
  }
}

class _EmptyLocation extends Location {
  const _EmptyLocation({
    required super.name,
    required super.latitude,
    required super.longitude,
  });
}
