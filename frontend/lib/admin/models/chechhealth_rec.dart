class Age {
  final int years;
  final int months;
  final int days;

  Age({required this.years, required this.months, required this.days});

  factory Age.fromJson(Map<String, dynamic> json) {
    return Age(
      years: json['years'],
      months: json['months'],
      days: json['days'],
    );
  }
}

class ToAge {
  final int years;
  final int months;
  final int days;

  ToAge({required this.years, required this.months, required this.days});

  factory ToAge.fromJson(Map<String, dynamic> json) {
    return ToAge(
      years: json['years'],
      months: json['months'],
      days: json['days'],
    );
  }
}

class HealthRecord {
  final int HR_id;
  final String header;
  final String petType;
  final Age age;
  final ToAge toAge;
  final double weightStartMonths;
  final double weightEndMonths;
  final String description;
  final DateTime recordDate;

  HealthRecord({
    required this.HR_id,
    required this.header,
    required this.petType,
    required this.age,
    required this.toAge,
    required this.weightStartMonths,
    required this.weightEndMonths,
    required this.description,
    required this.recordDate,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      HR_id: json['HR_id'],
      header: json['header'],
      petType: json['pet_type'],
      age: Age.fromJson(json['age']),
      toAge: ToAge.fromJson(json['to_age']),
      weightStartMonths: json['weight_start_months'],
      weightEndMonths: json['weight_end_months'],
      description: json['description'] ?? '',
      recordDate: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'HR_id': HR_id,
      'header': header,
      'pet_type': petType,
      'age': {
        'years': age.years,
        'months': age.months,
        'days': age.days,
      },
      'to_age': {
        'years': toAge.years,
        'months': toAge.months,
        'days': toAge.days,
      },
      'weight_start_months': weightStartMonths,
      'weight_end_months': weightEndMonths,
      'description': description,
      'record_date': recordDate.toIso8601String(),
    };
  }
}
