import 'package:flutter/material.dart';
import 'package:invoiceninja_flutter/utils/formatting.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({
    Key key,
    @required this.labelText,
    @required this.onSelected,
    @required this.timeOfDay,
    this.validator,
    this.autoValidate = false,
  }) : super(key: key);

  final String labelText;
  final TimeOfDay timeOfDay;
  final Function(TimeOfDay) onSelected;
  final Function validator;
  final bool autoValidate;

  @override
  _TimePickerState createState() => new _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  final _textController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (widget.timeOfDay != null) {
      _textController.text = formatDate(
          convertTimeOfDayToDateTime(widget.timeOfDay).toIso8601String(), context,
          showDate: false, showTime: true);
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showDatePicker() async {
    final selectedDate = widget.timeOfDay;
    final now = DateTime.now();

    final hour = selectedDate?.hour ?? now.hour;
    final minute = selectedDate?.minute ?? now.minute;

    final TimeOfDay selectedTime = await showTimePicker(
        context: context, initialTime: TimeOfDay(hour: hour, minute: minute));

    if (selectedTime != null) {
      _textController.text = formatDate(
          convertTimeOfDayToDateTime(selectedTime).toIso8601String(), context,
          showTime: true, showDate: false);

      widget.onSelected(selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDatePicker(),
      child: IgnorePointer(
        child: TextFormField(
          validator: widget.validator,
          autovalidate: widget.autoValidate,
          controller: _textController,
          decoration: InputDecoration(
            labelText: widget.labelText,
            suffixIcon: Icon(Icons.access_time),
          ),
        ),
      ),
    );
  }
}
