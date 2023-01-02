import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../home/widget_store.dart';
import '../../model/location_response.dart';
import '../../model/widget_settings.dart';
import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../ui/alignment_control.dart';
import '../../ui/custom_dropdown.dart';
import '../../ui/custom_slider.dart';
import '../../ui/text_input.dart';
import '../../utils/custom_observer.dart';
import '../../utils/geocoding_service.dart';

class WeatherWidgetSettingsView extends StatelessWidget {
  const WeatherWidgetSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<WidgetStore>().weatherSettings;
    return Column(
      children: [
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Font',
          builder: (context) {
            return CustomDropdown<String>(
              isExpanded: true,
              value: settings.fontFamily,
              items: FontFamilies.fonts,
              onSelected: (family) =>
                  settings.update(() => settings.fontFamily = family),
            );
          },
        ),
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Font size',
          builder: (context) {
            return CustomSlider(
              min: 10,
              max: 400,
              valueLabel: '${settings.fontSize.floor().toString()} px',
              value: settings.fontSize,
              onChanged: (value) => settings
                  .update(() => settings.fontSize = value.floorToDouble()),
            );
          },
        ),
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Position',
          builder: (context) {
            return AlignmentControl(
              alignment: settings.alignment,
              onChanged: (alignment) =>
                  settings.update(() => settings.alignment = alignment),
            );
          },
        ),
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Format',
          builder: (context) {
            return CustomDropdown<WeatherFormat>(
              isExpanded: true,
              value: settings.format,
              items: WeatherFormat.values,
              itemBuilder: (context, item) => Text(item.label),
              onSelected: (format) =>
                  settings.update(() => settings.format = format),
            );
          },
        ),
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Location (city)',
          builder: (context) {
            return LocationAutoCompleteField(
              key: ValueKey(settings.location),
              location: settings.location,
              onChanged: (location) {
                if (location.latitude == settings.location.latitude &&
                    location.longitude == settings.location.longitude) {
                  return;
                }
                settings.update(() => settings.location = location);
              },
            );
          },
        ),
        const SizedBox(height: 16),
        LabeledObserver(
          label: 'Temperature unit',
          builder: (context) {
            return CustomDropdown<TemperatureUnit>(
              isExpanded: true,
              value: settings.temperatureUnit,
              items: TemperatureUnit.values,
              itemBuilder: (context, item) => Text(item.label),
              onSelected: (unit) =>
                  settings.update(() => settings.temperatureUnit = unit),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class LocationAutoCompleteField extends StatefulWidget {
  final String? label;
  final Location location;
  final ValueChanged<Location> onChanged;

  const LocationAutoCompleteField({
    super.key,
    this.label,
    required this.location,
    required this.onChanged,
  });

  @override
  State<LocationAutoCompleteField> createState() =>
      _LocationAutoCompleteFieldState();
}

class _LocationAutoCompleteFieldState extends State<LocationAutoCompleteField> {
  late final AsyncDeBouncer _deBouncer =
      AsyncDeBouncer(const Duration(milliseconds: 700));

  late final GeocodingService geocodingService =
      GetIt.instance.get<GeocodingService>();

  ValueNotifier<bool> loadingNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!),
          const SizedBox(height: 10),
        ],
        Autocomplete<LocationResponse>(
          initialValue: TextEditingValue(
              text: '${widget.location.name}'
                  '${widget.location.country.isNotEmpty ? ', ${widget.location.country}' : ''}'),
          optionsMaxHeight: 180,
          displayStringForOption: (option) =>
              '${option.name}, ${option.country}',
          onSelected: (item) {
            // log('onSelected: $item');
            _deBouncer.cancel();
            if (item is _EmptyLocation) return;
            if (item is _LocationError) return;
            widget.onChanged(item.toLocation());
          },
          optionsBuilder: (textEditingValue) async {
            if (textEditingValue.text.isEmpty) {
              _deBouncer.cancel();
              if (mounted) loadingNotifier.value = false;
              return [const _EmptyLocation()];
            }
            loadingNotifier.value = true;
            return _deBouncer.run<List<LocationResponse>>(() async {
              log('optionsBuilder: ${textEditingValue.text.trim()}');
              try {
                final List<LocationResponse> response =
                    await fetchLocations(textEditingValue.text.trim());
                if (mounted) loadingNotifier.value = false;
                return response;
              } catch (e) {
                if (mounted) loadingNotifier.value = false;
                return [const _LocationError()];
              }
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
                      const BoxConstraints(maxHeight: 250, maxWidth: 310),
                  decoration: BoxDecoration(
                    color: AppColors.dropdownOverlayColor,
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
                        final bool isError = index == 0 &&
                            options.length == 1 &&
                            options.first is _LocationError;
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
                        if (isError) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Align(
                              alignment: Alignment.center,
                              heightFactor: 1,
                              child: Text(
                                'Failed to fetch locations',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red.shade400,
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
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 28,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Image.network(
                                      getFlagUrl(location.countryCode),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          location.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          getDescription(location),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                fontWeight: FontWeight.w300,
                                                color: selected
                                                    ? Colors.grey.shade200
                                                    : Colors.grey.shade400,
                                                fontSize: 12,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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

  Future<List<LocationResponse>> fetchLocations(String query) async {
    final response = await geocodingService.fetchLocations(query);
    return response;
  }

  @override
  void dispose() {
    loadingNotifier.dispose();
    super.dispose();
  }

  String getDescription(LocationResponse location) {
    final List<String> components = [
      location.description3,
      location.description2,
      location.description1,
      location.country,
    ].whereNotNull().where((element) => element.isNotEmpty).toList();

    return components.join(', ');
  }

  String getFlagUrl(String countryCode) {
    return 'https://countryflagsapi.com/png/$countryCode';
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

class _EmptyLocation extends LocationResponse {
  const _EmptyLocation()
      : super(
          name: 'Empty',
          latitude: -1,
          longitude: -1,
          country: '',
          countryCode: '',
          timezone: '',
          description1: '',
          description2: '',
          description3: '',
          elevation: -1,
        );
}

class _LocationError extends LocationResponse {
  const _LocationError()
      : super(
          name: 'Error',
          latitude: -1,
          longitude: -1,
          country: '',
          countryCode: '',
          timezone: '',
          description1: '',
          description2: '',
          description3: '',
          elevation: -1,
        );
}
