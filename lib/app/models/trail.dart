class Trail {
  final int id;
  final String name;
  final String description;

  Trail(this.id, this.name, this.description);

  factory Trail.fromMap(Map<String, dynamic> map) {
    return Trail(map['id'], map['name'], map['description']);
  }
}
