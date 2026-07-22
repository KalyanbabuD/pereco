import 'package:flutter/material.dart';

class ReportDatePicker extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final ValueChanged<DateTime?>? onDateSelected;

  const ReportDatePicker({
    super.key,
    required this.label,
    this.initialDate,
    this.onDateSelected,
  });

  @override
  State<ReportDatePicker> createState() => _ReportDatePickerState();
}

class _ReportDatePickerState extends State<ReportDatePicker> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate != null 
                    ? '${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year}' 
                    : 'dd-mm-yyyy',
                  style: TextStyle(color: _selectedDate != null ? Colors.black87 : Colors.grey.shade500, fontSize: 14),
                ),
                Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade700),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
