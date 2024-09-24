class PetProfile {
  final String status;
  final int petsId;
  final String name;
  final String typePets;
  final String sex;
  final String breed;
  final String birthDate;
  final double weight;
  final int userId;
  final String ownerName;

  PetProfile({
    required this.status,
    required this.petsId,
    required this.name,
    required this.typePets,
    required this.sex,
    required this.breed,
    required this.birthDate,
    required this.weight,
    required this.userId,
    required this.ownerName,
  });

  factory PetProfile.fromJson(Map<String, dynamic> json) {
    return PetProfile(
      status: json['status'],
      petsId: json['pets_id'],
      name: json['name'],
      typePets: json['type_pets'],
      sex: json['sex'],
      breed: json['breed'],
      birthDate: json['birth_date'],
      weight: json['weight'],
      userId: json['user_id'],
      ownerName: json['owner_name'],
    );
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

