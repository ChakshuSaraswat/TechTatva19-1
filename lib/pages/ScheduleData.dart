
class ScheduleData1{
  final int id, event, round;
  final String start, end, location;

  ScheduleData1({this.id, this.event, this.round, this.start, this.end, this.location});
  // factory Data.fromJson(Map<String, dynamic> parsedJson) {
  //   return Data(
  //       id: parsedJson['id'],
  //       event: parsedJson['event'],
  //       round: parsedJson['round'],
  //       start: parsedJson['start'],
  //       end: parsedJson['end'],
  //       location: parsedJson['location']);
  // }
}


// class ScheduleData {
//   final String success;
//   final List<Data> data;

//   ScheduleData({this.success, this.data});

//   factory ScheduleData.fromJson(Map<String, dynamic> parsedJson) {
//     var list = parsedJson['data'] as List;
//     print(list.runtimeType);

//     List<Data> datalist = list.map((i) => Data.fromJson(i)).toList();

//     return ScheduleData(success: parsedJson['success'], data: datalist);
//   }
//}

