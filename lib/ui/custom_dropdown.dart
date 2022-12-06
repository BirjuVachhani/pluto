import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdown2<T> extends StatelessWidget {
  final List<T> items;
  final ValueChanged<T> onSelected;
  final String? label;
  final Widget Function(BuildContext context, T item)? itemBuilder;
  final T? value;
  final bool isExpanded;

  const CustomDropdown2({
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
        DropdownButtonFormField<T>(
          value: value,
          isExpanded: isExpanded,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.w400, height: 1),
          // underline: const SizedBox.shrink(),
          // dropdownColor: Colors.red,
          decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey.withOpacity(0.15),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
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
      ],
    );
  }
}

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final ValueChanged<T> onSelected;
  final String? label;
  final Widget Function(BuildContext context, T item)? itemBuilder;
  final T? value;
  final bool isExpanded;
  final double itemHeight;
  final double dropdownMaxHeight;
  final bool searchable;
  final Widget Function(BuildContext context, T item)? selectedItemBuilder;

  final bool Function(DropdownMenuItem item, String searchValue)? searchMatchFn;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onSelected,
    this.value,
    this.label,
    this.itemBuilder,
    this.isExpanded = true,
    this.itemHeight = 36,
    this.dropdownMaxHeight = 500,
    this.searchMatchFn,
    this.searchable = false,
    this.selectedItemBuilder,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultSelectionStyle(
      cursorColor: Colors.black,
      selectionColor: Colors.black.withOpacity(0.15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.label != null) Text(widget.label!),
          if (widget.label != null) const SizedBox(height: 10),
          DropdownButton2<T>(
            value: widget.value,
            isExpanded: widget.isExpanded,
            barrierDismissible: true,
            // offset: const Offset(0, 0),
            itemHeight: widget.itemHeight,
            buttonHeight: 44,
            dropdownOverButton: false,
            buttonElevation: 0,
            dropdownMaxHeight: widget.dropdownMaxHeight,
            scrollbarThickness: 4,
            dropdownElevation: 2,
            selectedItemHighlightColor: Colors.grey.shade300,
            dropdownPadding: EdgeInsets.zero,
            searchInnerWidget: widget.searchable
                ? SearchBar(controller: searchController)
                : null,
            onMenuStateChange: (isOpen) {
              if (!isOpen) searchController.clear();
            },
            searchMatchFn: widget.searchable
                ? widget.searchMatchFn ?? defaultSearchFn
                : null,
            searchController: widget.searchable ? searchController : null,
            buttonPadding: const EdgeInsets.only(right: 12),
            underline: const SizedBox.shrink(),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w400, height: 1),
            buttonDecoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
            ),
            items: [
              for (final item in widget.items)
                DropdownMenuItem<T>(
                  value: item,
                  alignment: Alignment.centerLeft,
                  child: widget.itemBuilder?.call(context, item) ??
                      Text(item.toString()),
                ),
            ],
            selectedItemBuilder: widget.selectedItemBuilder != null
                ? (context) => [
                      for (final item in widget.items)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: widget.selectedItemBuilder!(context, item),
                        ),
                    ]
                : null,
            onChanged: (value) {
              if (value == null) return;
              if (value == widget.value) return;
              widget.onSelected(value);
            },
          ),
        ],
      ),
    );
  }

  bool defaultSearchFn(DropdownMenuItem item, String searchValue) {
    return item.value
        .toString()
        .toLowerCase()
        .contains(searchValue.toLowerCase());
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const SearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search',
          filled: true,
          prefixIcon: const Icon(Icons.search_rounded),
          fillColor: Colors.grey.withOpacity(0.1),
          hintStyle: const TextStyle(fontSize: 13, height: 1.2),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
