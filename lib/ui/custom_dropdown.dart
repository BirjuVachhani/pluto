import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final ValueChanged<T> onSelected;
  final String? label;
  final Widget Function(BuildContext context, T item)? itemBuilder;
  final T? value;
  final bool isExpanded;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onSelected,
    this.value,
    this.label,
    this.itemBuilder,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) Text(label!),
        if (label != null) const SizedBox(height: 10),
        Container(
          color: Colors.grey.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<T>(
            value: value,
            isExpanded: isExpanded,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w400, height: 1),
            underline: const SizedBox.shrink(),
            // dropdownColor: Colors.red,
            menuMaxHeight: 700,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
            ),
            items: items
                .map((item) => DropdownMenuItem<T>(
                      value: item,
                      alignment: Alignment.centerLeft,
                      child: itemBuilder?.call(context, item) ??
                          Text(item.toString()),
                    ))
                .toList(),
            onChanged: (mode) {
              if (mode == null) return;
              onSelected(mode);
            },
          ),
        ),
      ],
    );
  }
}
