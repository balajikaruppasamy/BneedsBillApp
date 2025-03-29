import 'package:flutter/material.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';

class CommonCompanyDropdown extends StatelessWidget {
  final List<String> items;
  final String? hintText;
  final ValueChanged<String?> onChanged;
  final String? selectedValue;
  final String labelText;
  final IconData? prefixIcon;

  const CommonCompanyDropdown({
    Key? key,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.selectedValue,
    required this.labelText,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: -10, horizontal: 20),
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
      ),
      child: SearchableDropdown.single(
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
        value: selectedValue,
        hint: hintText,
        searchHint: "Search options",
        onChanged: onChanged,
        isExpanded: true,
        dialogBox: true,
      ),
    );
  }
}
