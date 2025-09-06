class ShariahCompliance {
  final bool compliant; // matches backend boolean field
  final String? notes;
  final DateTime? checkedDate;

  ShariahCompliance({
    required this.compliant,
    this.notes,
    this.checkedDate,
  });

  factory ShariahCompliance.fromJson(Map<String, dynamic> json) {
    return ShariahCompliance(
      compliant: json['compliant'] as bool? ?? false,
      notes: json['notes'],
      checkedDate: json['checkedDate'] != null ? DateTime.parse(json['checkedDate']) : null,
    );
  }

  String get status => compliant ? "Compliant" : "Non-Compliant";
}
