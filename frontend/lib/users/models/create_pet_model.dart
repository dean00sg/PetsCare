class PetModel {
  final String name;
  final String dateOfBirth;  // Rename to match the API's 'birth_date'
  final double weight;
  final String sex;
  final String breed;
  final String? imagePath;
  final String typePets;  // Match with 'type_pets' field

  PetModel({
    required this.name,
    required this.dateOfBirth,
    required this.weight,
    required this.sex,
    required this.breed,
    required this.typePets,  // Ensure this field matches 'type_pets'
    this.imagePath,
  });
}
