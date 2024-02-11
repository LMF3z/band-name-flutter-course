class BandModel {
  String id;
  String name;
  int votes;

  BandModel({
    required this.id,
    required this.name,
    required this.votes,
  });

  factory BandModel.fromMap(Map<String, dynamic> obj) {
    return BandModel(
      id: obj['id'] ?? 'no-id',
      name: obj['name'] ?? 'no-name',
      votes: obj['votes'] ?? 'no votes',
    );
  }
}
