class District {
  int id;
  String? name;

  District({
    required this.id,
    this.name,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'] as int,
      name: json["name"] as String?,
    );
  }
}
