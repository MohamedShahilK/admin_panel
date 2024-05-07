class CheckInModel {
  final String ticketNo;
  final String checkinTime;
  final String checkinUpdationTime;
  final String requestTime;
  final String onTheWayTime;
  final String carBrand;
  final String carColour;
  final String cvaIn;
  final String emirates;
  final String plateNo;
  final String status;

  const CheckInModel({
    required this.ticketNo,
    required this.checkinTime,
    required this.checkinUpdationTime,
    required this.requestTime,
    required this.onTheWayTime,
    required this.carBrand,
    required this.carColour,
    required this.cvaIn,
    required this.emirates,
    required this.plateNo,
    required this.status,
  });

  CheckInModel copyWith({
    required String ticketNo,
    required String checkinTime,
    required String checkinUpdationTime,
    required String requestTime,
    required String onTheWayTime,
    required String carBrand,
    required String carColour,
    required String cvaIn,
    required String emirates,
    required String plateNo,
    required String status,
  }) =>
      CheckInModel(
        ticketNo: ticketNo,
        checkinTime: checkinTime ,
        checkinUpdationTime: checkinUpdationTime ,
        requestTime: requestTime ,
        onTheWayTime: onTheWayTime ,
        carBrand: carBrand ,
        carColour: carColour ,
        cvaIn: cvaIn ,
        emirates: emirates ,
        plateNo: plateNo ,
        status: status ,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is CheckInModel &&
          runtimeType == other.runtimeType &&
          ticketNo == other.ticketNo &&
          checkinTime == other.checkinTime &&
          checkinUpdationTime == other.checkinUpdationTime &&
          requestTime == other.requestTime &&
          onTheWayTime == other.onTheWayTime &&
          carBrand == other.carBrand &&
          carColour == other.carColour &&
          cvaIn == other.cvaIn &&
          emirates == other.emirates &&
          plateNo == other.plateNo &&
          status == other.status;

  @override
  int get hashCode =>
      super.hashCode ^
      ticketNo.hashCode ^
      checkinTime.hashCode ^
      checkinUpdationTime.hashCode ^
      requestTime.hashCode ^
      onTheWayTime.hashCode ^
      carBrand.hashCode ^
      carColour.hashCode ^
      cvaIn.hashCode ^
      emirates.hashCode ^
      plateNo.hashCode ^
      status.hashCode;
}
