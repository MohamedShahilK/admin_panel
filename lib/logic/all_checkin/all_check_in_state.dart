import 'dart:io';

import 'package:rxdart/rxdart.dart';

class AllCheckInState {
  factory AllCheckInState() {
    return _singleton;
  }

  AllCheckInState._internal();

  static final AllCheckInState _singleton = AllCheckInState._internal();

  final barcodeStream = BehaviorSubject<String>.seeded('');
  final carBrandStream = BehaviorSubject<String>.seeded('');
  final carColorStream = BehaviorSubject<String>.seeded('');
  final phoneNumberStream = BehaviorSubject<String>.seeded('');
  final plateNumberStream = BehaviorSubject<String>.seeded('');
  final roomNumberStream = BehaviorSubject<String>.seeded('');
  final statusStream = BehaviorSubject<String>.seeded('');

  final carSelectionStream = BehaviorSubject<String>.seeded('All');
  final commentsStream = BehaviorSubject<String>.seeded('');
  final imageFileListForAll = BehaviorSubject<List<File>>.seeded([]);
  final imageFileListForFrontSide = BehaviorSubject<List<File>>.seeded([]);
  final imageFileListForBackSide = BehaviorSubject<List<File>>.seeded([]);
  final imageFileListForTopSide = BehaviorSubject<List<File>>.seeded([]);
  final imageFileListForLeftSide = BehaviorSubject<List<File>>.seeded([]);
  final imageFileListForRightSide = BehaviorSubject<List<File>>.seeded([]);
  final carSidesList = BehaviorSubject<List<String>>.seeded([
    'All',
    'Front Side',
    'Back Side',
    'Top Side',
    'Left Side',
    'Right Side',
  ]);
  void dispose() {
    barcodeStream.close();
    carBrandStream.close();
    carColorStream.close();
    carSelectionStream.close();
    commentsStream.close();
    imageFileListForAll.close();
    imageFileListForFrontSide.close();
    imageFileListForBackSide.close();
    imageFileListForTopSide.close();
    imageFileListForLeftSide.close();
    imageFileListForRightSide.close();
    carSidesList.close();
  }
}
