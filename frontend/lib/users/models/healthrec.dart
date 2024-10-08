class Age {
  final int years;
  final int months;
  final int days;

  Age({
    required this.years, 
    required this.months, 
    required this.days,
    });

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

class HealthRecordUser {
  final int hrId;
  final String header;
  final String petType;
  final Age age;
  final ToAge toAge;
  final double weightStartMonths;
  final double weightEndMonths;
  final String recordDate;
  final String description;

  HealthRecordUser({
    required this.hrId,
    required this.header,
    required this.petType,
    required this.age,
    required this.toAge,
    required this.weightStartMonths,
    required this.weightEndMonths,
    required this.recordDate,
    required this.description,
  });

  factory HealthRecordUser.fromJson(Map<String, dynamic> json) {
    return HealthRecordUser(
      hrId: json['HR_id'],
      header: json['header'],
      petType: json['pet_type'],
      age: Age.fromJson(json['age']),
      toAge: ToAge.fromJson(json['to_age']),
      weightStartMonths: json['weight_start_months'],
      weightEndMonths: json['weight_end_months'],
      recordDate: json['record_date'],
      description: json['description'],
    );
  }
}
