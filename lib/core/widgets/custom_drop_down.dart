import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final String label;
  final String? hintText;
  final String? errorText;
  final bool isExpanded;
  final Color? fillColor;
  final Color? textColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? contentPadding;

  const CustomDropDown({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.label,
    this.hintText,
    this.errorText,
    this.isExpanded = true,
    this.fillColor,
    this.textColor,
    this.borderColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
        ],

        // Dropdown
        Container(
          decoration: BoxDecoration(
            color: fillColor ?? Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null
                  ? Colors.red
                  : borderColor ?? Colors.grey.shade400,
            ),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: selectedValue,
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    color: textColor ?? Colors.black87,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            isExpanded: isExpanded,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              errorText: errorText,
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: errorText != null ? Colors.red : const Color(0xFF0040FF),
            ),
            style: TextStyle(color: textColor ?? Colors.black87, fontSize: 16),
            dropdownColor: fillColor ?? Colors.white,
            borderRadius: BorderRadius.circular(12),
            hint: hintText != null
                ? Text(
                    hintText!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
