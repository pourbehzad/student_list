class User {
    final String name;
    final List<String> courses;
    final String number;
    final String id;

    User({
        required this.name,
        required this.courses,
        required this.number,
        required this.id,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        courses: List<String>.from(json["courses"].map((x) => x)),
        number: json["number"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "courses": List<dynamic>.from(courses.map((x) => x)),
        "number": number,
        "id": id,
    };
}
