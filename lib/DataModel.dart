class ScheduleData {
  final int id;
  final int eventId;
  final int round;
  final String name;
  final int categoryId;
  final DateTime startTime;
  final DateTime endTime;
  final String location;

  ScheduleData(
      {this.id,
      this.eventId,
      this.round,
      this.name,
      this.categoryId,
      this.startTime,
      this.endTime,
      this.location});
}

class CategoryData {
  final int id;
  final String name;
  final String description;
  final String type;
  final String cc1Name;
  final String cc1Contact;
  final String cc2Name;
  final String cc2Contact;
  final List<int> eventIds;

  CategoryData(
      {this.id,
      this.name,
      this.description,
      this.type,
      this.cc1Name,
      this.cc1Contact,
      this.cc2Name,
      this.cc2Contact,
      this.eventIds});
}

class EventData{
  final int id;
  final int categoryId;
  final String name;
  final int free;
  final String description;
  final int minTeamSize;
  final int maxTeamSize;
  final int delCardType;

  EventData({
    this.id,
    this.categoryId,
    this.name,
    this.free,
    this.description,
    this.minTeamSize,
    this.maxTeamSize,
    this.delCardType
  });
}

class ResultData{
  final int eventId;
  final int teamId;
  final int position;
  final int round;

  ResultData({
    this.eventId,
    this.teamId,
    this.position,
    this.round
  });
}