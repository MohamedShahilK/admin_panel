// ignore_for_file: lines_longer_than_80_chars

import 'package:admin_panel/utils/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    required this.value,
    required this.field,
    required this.list,
    required this.onChanged,
    required this.labelText,
    this.labelstyle,
    this.isFiltering = false,
    super.key,
    this.isReg = false,
    this.isCarImagesPage = false,
  });

  final String value;
  final String field;
  final List<String> list;
  final bool isReg;
  final bool isFiltering;
  final bool isCarImagesPage;
  final void Function(String?)? onChanged;
  final String labelText;
  final TextStyle? labelstyle;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  // String dropdownValue = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.only(bottom: 10),
          //   child: Text(
          //     widget.field,
          //     style: AppStyles.fieldHeadingStyle,
          //   ),
          // ),
          // ignore: avoid_unnecessary_containers, sized_box_for_whitespace
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width / 5,
            decoration: BoxDecoration(
              // color: Colors.grey[200],
              // color: AppColors.fillColor,
              // color: Colors.white,
              // borderRadius: BorderRadius.circular(5),
              borderRadius: BorderRadius.circular(10),
              // border: Border.all(color: AppColors.borderColor),
            ),
            child: DropdownButton2<String>(
              style: GoogleFonts.openSans().copyWith(
                color: Colors.grey[700],
                fontSize: 10.5,
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: textEditingController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Container(
                  height: 50,
                  padding: const EdgeInsets.only(right: 8, left: 8, top: 15),
                  child: TextFormField(
                    expands: true,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                    maxLines: null,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      hintText: 'Search for an item...',
                      hintStyle: const TextStyle(fontSize: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          // color: Color.fromARGB(146, 146, 69, 197),
                          color: secondaryColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          // color: Color.fromARGB(146, 146, 69, 197),
                          color: secondaryColor,
                        ),
                      ),
                      // focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return item.value.toString().contains(
                        searchValue.toUpperCase(),
                      );
                },
              ),
              buttonStyleData: ButtonStyleData(
                height: 35,
                padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    // color: const Color.fromARGB(146, 146, 69, 197),
                    color: secondaryColor,
                  ),
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                // width: widget.isFiltering ? 130.w : 250,
                width: 150,
                // padding: null,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  // color: Colors.redAccent,
                ),
              ),
              // value: dropdownValue == '' ? null : dropdownValue,

              // Value
              value: widget.value,
              // Value

              menuItemStyleData: MenuItemStyleData(
                height: widget.isFiltering ? 30 : 32,
              ),

              underline: const SizedBox(),
              isExpanded: true,

              iconStyleData: const IconStyleData(iconEnabledColor: secondaryColor),
              onChanged: widget.onChanged,
              items: widget.list
                  .map<DropdownMenuItem<String>>(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: item == ''
                            ? Text(
                                !widget.isReg ? widget.labelText : 'Country Of Registraion',
                                style: GoogleFonts.openSans().copyWith(
                                  color: Colors.grey[700],
                                  fontSize:12,
                                ),
                              )
                            : Text(
                                item,
                                style: const TextStyle(
                                    // color: AppColors.dropDownItemColor,
                                    ),
                              ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
