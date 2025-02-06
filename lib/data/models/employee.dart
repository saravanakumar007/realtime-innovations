class Employee {
  const Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.startDate,
    this.endDate,
  });
  final int id;
  final String name;
  final String role;
  final DateTime startDate;
  final DateTime? endDate;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate != null ? endDate!.millisecondsSinceEpoch : null
    };
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate']),
      endDate: json['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['endDate'])
          : null,
    );
  }
}
