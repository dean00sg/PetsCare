class PetProfileUserModel {
  final String name;
  final String type_pets;
  final String sex;
  final String breed;
  final String birth_date;
  final double weight;
  final String owner_name;

  PetProfileUserModel({
    required this.name,
    required this.type_pets,
    required this.sex,
    required this.breed,
    required this.birth_date,
    required this.weight,
    required this.owner_name,
  });

  factory PetProfileUserModel.fromJson(Map<String, dynamic> json) {
    return PetProfileUserModel(
      name: json['name'],
      type_pets: json['type_pets'],
      sex: json['sex'],
      breed: json['breed'],
      birth_date: json['birth_date'],
      weight: json['weight'],
      owner_name: json['owner_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type_pets': type_pets,
      'sex': sex,
      'breed': breed,
      'birth_date': birth_date,
      'weight': weight,
      'owner_name': owner_name,
    };
  }
}

class PetTypeImage {
  static const Map<String, String> petTypeToImage = {
    'Cat': 'lib/images/cat_icon.png',
    'Dog': 'lib/images/dog_icon.png',
    'Rabbit': 'lib/images/rabbit_icon.png',
    'Fish': 'lib/images/fish_icon.png',
  };

  static String getImagePath(String type) {
    return petTypeToImage[type] ?? 'lib/images/default_pet_icon.png';
  }
}
