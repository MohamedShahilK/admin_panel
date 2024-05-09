import 'dart:async';

import 'package:admin_panel/data/checkin_model.dart';
import 'package:admin_panel/models/user.dart';
import 'package:admin_panel/screens/dashboard/components/header.dart';
import 'package:admin_panel/screens/widgets/custom_dropdown.dart';
import 'package:admin_panel/screens/widgets/scrollable_widget.dart';
import 'package:admin_panel/utils/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // var isLoading = true;

  // @override
  // void didChangeDependencies() {
  //   customLoader(context);
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     Future.delayed(
  //       const Duration(milliseconds: 300),
  //       () => setState(() {
  //         isLoading = false;
  //         Loader.hide();
  //       }),
  //     );
  //   });
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Stack(
        children: [
          _AllTicketsSection(),
          // _NewCheckInForm(),

          // Header
          Header(),
        ],
      ),
    );
  }
}

class _DropDown extends StatefulWidget {
  const _DropDown({
    // required this.items,
    required this.field,
  });

  // final List<String> items;
  final String field;

  @override
  State<_DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<_DropDown> {
  var selectedValue = '';
  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of<ParkedBloc>(context, listen: false);
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Text(
          widget.field,
          style: GoogleFonts.openSans().copyWith(
            color: Colors.grey[900],
            fontWeight: FontWeight.w900,
            fontSize: 10.5,
          ),
        ),
        style: GoogleFonts.openSans().copyWith(
          color: Colors.grey[900],
          fontWeight: FontWeight.w900,
          fontSize: 10.5,
        ),
        items: [
          // '',
          'DUBAI',
          'ABU DHABI',
          'AJMAN',
          'Driver 4',
        ].map((e) => DropdownMenuItem(child: Align(child: Text(e)), value: e)).toList(),
        value: selectedValue == '' ? null : selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value!;
          });
          // bloc.sourceIdStream.add(value);
          // //print('111111111111111 $selectedValue');
        },
        iconStyleData: const IconStyleData(iconEnabledColor: secondaryColor, iconDisabledColor: secondaryColor),
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: 160,
          padding: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: const Color.fromARGB(146, 146, 69, 197),
            ),
            color: Colors.grey[200],
            // color: Colors.white,
          ),
          elevation: 2,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
        alignment: Alignment.center,
        dropdownStyleData: DropdownStyleData(
          offset: const Offset(-45, 0),
          maxHeight: 200,
          width: 188,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(width: .3, color: Colors.grey),
            color: Colors.grey[300],
          ),
          // offset: const Offset(-20, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
      ),
    );
  }
}

class _PlateTextField extends StatefulWidget {
  const _PlateTextField({
    // required this.textStream,
    required this.onTextChanged,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.width = 0,
    this.textAlign,
    this.contentPadding,
    this.hintStyle,
  });

  // final BehaviorSubject<String> textStream;
  final void Function(String) onTextChanged;
  final String hintText;
  final TextInputType keyboardType;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final double width;

  @override
  State<_PlateTextField> createState() => _PlateTextFieldState();
}

class _PlateTextFieldState extends State<_PlateTextField> {
  // final _controller = TextEditingController();
  // @override
  // void initState() {
  //   widget.textStream.listen((value) {
  //     if (value.isEmpty) {
  //       _controller.clear();
  //     } else if (_controller.text != value) {
  //       _controller.text = value;
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextFormField(
        scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 15 * 6, // Adjust the value as needed
        ),
        // controller: _controller,
        onChanged: widget.onTextChanged,
        keyboardType: widget.keyboardType,
        textCapitalization: TextCapitalization.characters,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        textAlign: widget.textAlign ?? TextAlign.left,
        decoration: InputDecoration(
          hintText: widget.hintText,
          // hintStyle: TextStyle(fontSize: 12.w),
          hintStyle: widget.hintStyle ??
              GoogleFonts.openSans().copyWith(
                color: Colors.grey[700],
                fontSize: 10.5,
              ),
          // contentPadding: EdgeInsets.only(left: 15.w),
          contentPadding: widget.contentPadding ?? const EdgeInsets.only(top: 5),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(146, 146, 69, 197),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              // color: Color.fromARGB(255, 80, 19, 121),
              color: Color.fromARGB(146, 146, 69, 197),
            ),
          ),
        ),
      ),
    );
  }
}

class _AllTicketsSection extends StatelessWidget {
  const _AllTicketsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: const IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter
                  _CustomExpansionTile(),

                  // Table
                  _Table()
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _Table extends StatelessWidget {
  const _Table({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 40, top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: secondaryColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.download_for_offline_outlined, color: secondaryColor),
                        const SizedBox(width: 10),
                        Text(
                          'Download'.toUpperCase(),
                          // style:  TextStyle(color: Colors.grey[700], fontSize: 18,fontWeight: FontWeight.w700),
                          style: GoogleFonts.poppins().copyWith(color: secondaryColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total Tickets:'.toUpperCase(),
                          // style:  TextStyle(color: Colors.grey[700], fontSize: 18,fontWeight: FontWeight.w700),
                          style: GoogleFonts.poppins().copyWith(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          // '50',
                          allUsers.length.toString(),
                          // style:  TextStyle(color: Colors.grey[700], fontSize: 18,fontWeight: FontWeight.w700),
                          style: GoogleFonts.poppins().copyWith(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: Container(
                // padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                // margin: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[200]!),
                  // borderRadius: BorderRadius.circular(30),
                ),
                child: SortablePage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SortablePage extends StatefulWidget {
  const SortablePage({super.key});

  @override
  _SortablePageState createState() => _SortablePageState();
}

class _SortablePageState extends State<SortablePage> {
  List<CheckInModel> users = [];
  int? sortColumnIndex;
  bool isAscending = false;
  late var timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        timer = Timer.periodic(
          const Duration(seconds: 2),
          (Timer t) {
            setState(() {
              users = List.of(allUsers);
            });
          },
        );
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScrollableWidget(child: buildDataTable());

  Widget buildDataTable() {
    final columns = ['Ticket No.', 'Checkin Time', 'Checkin Updation Time', 'Request Time', 'On the way Time', 'Car Brand', 'Car Colour', 'CVA-In', 'Emirates', 'Plate No.', 'Status'];

    return DataTable(
      headingRowColor: MaterialStateProperty.all(secondaryColor),
      // headingRowColor: MaterialStateProperty.all(Color(0xFFFBFCFC)),
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      dividerThickness: .1,
      dataRowMaxHeight: 50,
      onSelectAll: (value) {},
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(users),
      // decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey[400]!)),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(
              column,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              // textAlign: TextAlign.center,
            ),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<CheckInModel> users) {
    if (users.isEmpty) {
      return List.generate(1, (index) => DataRow(cells: getCells(['', '', '', '', '', '', '', '', '', '', ''])));
    }
    return users.map((CheckInModel user) {
      final cells = [
        user.ticketNo,
        user.checkinTime,
        user.checkinUpdationTime,
        user.requestTime,
        user.onTheWayTime,
        user.carBrand,
        user.carColour,
        user.cvaIn,
        user.emirates,
        user.plateNo,
        user.status,
      ];

      return DataRow(cells: getCells(cells));
    }).toList();
  }

  List<DataCell> getCells(List<dynamic> cells) {
    if (users.isEmpty) {
      return List.generate(
          11,
          (index) => DataCell(Skeletonizer(
                effect: const ShimmerEffect(),
                enabled: users.isEmpty,
                containersColor: Colors.grey[100],
                child: const Text(
                  'data',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              )));
    }
    return cells
        .map((data) => DataCell(
              Text(
                '$data',
                style: const TextStyle(color: Colors.black, fontSize: 12),
                // textAlign: TextAlign.center,
              ),
            ))
        .toList();
  }

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      users.sort((user1, user2) => compareString(ascending, user1.ticketNo, user2.ticketNo));
    } else if (columnIndex == 1) {
      users.sort((user1, user2) => compareString(ascending, user1.checkinTime, user2.checkinTime));
    } else if (columnIndex == 2) {
      users.sort((user1, user2) => compareString(ascending, user1.checkinUpdationTime, user2.checkinUpdationTime));
    } else if (columnIndex == 3) {
      users.sort((user1, user2) => compareString(ascending, user1.requestTime, user2.requestTime));
    } else if (columnIndex == 4) {
      users.sort((user1, user2) => compareString(ascending, user1.onTheWayTime, user2.onTheWayTime));
    } else if (columnIndex == 5) {
      users.sort((user1, user2) => compareString(ascending, user1.carBrand, user2.carBrand));
    } else if (columnIndex == 6) {
      users.sort((user1, user2) => compareString(ascending, user1.carColour, user2.carColour));
    } else if (columnIndex == 7) {
      users.sort((user1, user2) => compareString(ascending, user1.cvaIn, user2.cvaIn));
    } else if (columnIndex == 8) {
      users.sort((user1, user2) => compareString(ascending, user1.emirates, user2.emirates));
    } else if (columnIndex == 9) {
      users.sort((user1, user2) => compareString(ascending, user1.plateNo, user2.plateNo));
    } else if (columnIndex == 10) {
      users.sort((user1, user2) => compareString(ascending, user1.status, user2.status));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) => ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}

class _CustomExpansionTile extends StatefulWidget {
  const _CustomExpansionTile();

  @override
  State<_CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<_CustomExpansionTile> {
  bool showAllIcons = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,

          // iconTheme: IconThemeData(color: Colors.red)
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
          ),
          child: ExpansionTile(
            // trailing: const SizedBox.shrink(),
            iconColor: secondaryColor,
            tilePadding: EdgeInsets.zero,
            collapsedIconColor: secondaryColor,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  const Icon(Icons.menu, color: secondaryColor, size: 20),
                  const SizedBox(width: 30),
                  Text(
                    'Searching Filter'.toUpperCase(),
                    style: GoogleFonts.poppins().copyWith(color: secondaryColor, fontSize: 14, fontWeight: FontWeight.bold),
                    // textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            children: [
              Container(
                height: 170,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 10,
                  children: [
                    _FilterTextField(onTextChanged: (p0) {}, hintText: 'Select Start Date'),
                    _FilterTextField(onTextChanged: (p0) {}, hintText: 'Select End Date'),
                    _FilterTextField(onTextChanged: (p0) {}, hintText: 'Barcode'),
                    _FilterTextField(onTextChanged: (p0) {}, hintText: 'Plate Number'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'Car Brand'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'Car Color'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'Emirates'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'Outlets'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'Status'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'CVA IN'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'CVA OUT'),
                    CustomDropDown(value: '', field: '', list: const ['', "shahil"], onChanged: (p0) {}, labelText: 'Mobile Number'),

                    // Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                            // margin: const EdgeInsets.only(right: 50,top: 10,bottom: 5),
                            margin: const EdgeInsets.only(right: 20, top: 5, bottom: 10),
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.filter_alt_outlined),
                                const SizedBox(width: 10),
                                Text('FILTER', style: GoogleFonts.openSans().copyWith(fontSize: 12, fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterTextField extends StatefulWidget {
  const _FilterTextField({
    // required this.textStream,
    required this.onTextChanged,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.errorStream,
  });

  // final BehaviorSubject<String> textStream;
  final void Function(String) onTextChanged;
  final String hintText;
  final TextInputType keyboardType;
  final Stream<String>? errorStream;

  @override
  State<_FilterTextField> createState() => _FilterTextFieldState();
}

class _FilterTextFieldState extends State<_FilterTextField> {
  // final _controller = TextEditingController();
  // @override
  // void initState() {
  //   widget.textStream.listen((value) {
  //     if (value.isEmpty) {
  //       _controller.clear();
  //     } else if (_controller.text != value) {
  //       _controller.text = value;
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 35,
            width: MediaQuery.of(context).size.width / 5,
            child: TextField(
              // controller: _controller,
              onChanged: widget.onTextChanged,
              keyboardType: widget.keyboardType,
              style: GoogleFonts.openSans().copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
              decoration: InputDecoration(
                hintText: widget.hintText,
                // hintStyle: GoogleFonts.openSans().copyWith(fontSize: 12),
                hintStyle: GoogleFonts.openSans().copyWith(
                  color: Colors.grey[700],
                  fontSize: 10.5,
                ),
                contentPadding: const EdgeInsets.only(left: 15),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  // borderSide: const BorderSide(color: Color.fromARGB(146, 146, 69, 197)),
                  borderSide: const BorderSide(color: secondaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    // color: Color.fromARGB(255, 80, 19, 121),
                    color: Color.fromARGB(146, 146, 69, 197),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class _FilterTextField extends StatefulWidget {
//   const _FilterTextField({
//     required this.textStream,
//     required this.onTextChanged,
//     required this.hintText,
//     required this.keyboardType,
//     this.errorStream,
//   });

//   final BehaviorSubject<String> textStream;
//   final void Function(String) onTextChanged;
//   final String hintText;
//   final TextInputType keyboardType;
//   final Stream<String>? errorStream;

//   @override
//   State<_FilterTextField> createState() => _FilterTextFieldState();
// }

// class _FilterTextFieldState extends State<_FilterTextField> {
//   final _controller = TextEditingController();
//   @override
//   void initState() {
//     widget.textStream.listen((value) {
//       if (value.isEmpty) {
//         _controller.clear();
//       } else if (_controller.text != value) {
//         _controller.text = value;
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 35,
//             child: TextField(
//               controller: _controller,
//               onChanged: widget.onTextChanged,
//               keyboardType: widget.keyboardType,
//               style: GoogleFonts.openSans().copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
//               decoration: InputDecoration(
//                 hintText: widget.hintText,
//                 // hintStyle: GoogleFonts.openSans().copyWith(fontSize: 12),
//                 hintStyle: GoogleFonts.openSans().copyWith(
//                   color: Colors.grey[700],
//                   fontSize: 10.5,
//                 ),
//                 contentPadding: EdgeInsets.only(left: 15),

//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Color.fromARGB(146, 146, 69, 197)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(
//                     // color: Color.fromARGB(255, 80, 19, 121),
//                     color: Color.fromARGB(146, 146, 69, 197),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // SizedBox(height: 10),
//           StreamBuilder<String>(
//             stream: widget.errorStream,
//             builder: (context, snapshot) {
//               final error = snapshot.data ?? '';
//               return StreamBuilder<String>(
//                 stream: widget.textStream,
//                 builder: (context, textSnapshot) {
//                   final textData = textSnapshot.data ?? '';
//                   // if (widget.isEmptyError &&
//                   //     textData.isEmpty &&
//                   //     error.isNotEmpty) {
//                   //   return _ErrorTextWidget(errorText: error);
//                   // } else if (!widget.isEmptyError && error.isNotEmpty) {
//                   //   return _ErrorTextWidget(errorText: error);
//                   // } else {
//                   //   return Container();
//                   // }
//                   if (textData.isEmpty && error.isNotEmpty) {
//                     return ErrorTextWidget(errorText: error);
//                   } else if (textData.isNotEmpty && error.isNotEmpty) {
//                     return ErrorTextWidget(errorText: error);
//                   } else {
//                     return Container();
//                   }
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
