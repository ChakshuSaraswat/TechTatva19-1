class EventData{
  final int id;
  final int categoryId;
  final String name;
  final int free;
  final String description;
  final int minTeamSize;
  final int maxTeamSize;
  final int delCardType;
  final int visible;
  final int canRegister;

  EventData({
    this.id,
    this.categoryId,
    this.name,
    this.free,
    this.description,
    this.minTeamSize,
    this.maxTeamSize,
    this.delCardType,
    this.visible,
    this.canRegister
  });
}
