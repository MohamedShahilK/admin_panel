import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

class FilterTextField extends StatefulWidget {
  const FilterTextField({
    required this.textStream,
    required this.onTextChanged,
    required this.hintText,
    required this.keyboardType,
    this.errorStream,
  });

  final BehaviorSubject<String> textStream;
  final void Function(String) onTextChanged;
  final String hintText;
  final TextInputType keyboardType;
  final Stream<String>? errorStream;

  @override
  State<FilterTextField> createState() => FilterTextFieldState();
}

class FilterTextFieldState extends State<FilterTextField> {
  final _controller = TextEditingController();
  @override
  void initState() {
    widget.textStream.listen((value) {
      if (value.isEmpty) {
        _controller.clear();
      } else if (_controller.text != value) {
        _controller.text = value;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: SizedBox(
        height: 35,
        width: MediaQuery.of(context).size.width / 5,
        child: TextField(
          controller: _controller,
          onChanged: widget.onTextChanged,
          keyboardType: widget.keyboardType,
          style: GoogleFonts.openSans().copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
          decoration: InputDecoration(
            hintText: widget.hintText,
            // hintStyle: GoogleFonts.openSans().copyWith(fontSize: 12.w),
            hintStyle: GoogleFonts.openSans().copyWith(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.normal),
            contentPadding: const EdgeInsets.only(left: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                // borderSide: const BorderSide(color: Color.fromARGB(146, 146, 69, 197)),
                borderSide: BorderSide(color: Colors.purple.withOpacity(.1))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                // borderSide: const BorderSide(
                //   // color: Color.fromARGB(255, 80, 19, 121),
                //   color: Color.fromARGB(146, 146, 69, 197),
                // ),
                borderSide: BorderSide(color: Colors.purple.withOpacity(.1))),
          ),
        ),
      ),
    );
  }
}
