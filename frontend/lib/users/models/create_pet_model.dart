class PetModel {
  final String name;
  final String dateOfBirth;  
  final double weight;
  final String sex;
  final String breed;
  final String? imagePath;
  final String typePets;  

  PetModel({
    required this.name,
    required this.dateOfBirth,
    required this.weight,
    required this.sex,
    required this.breed,
    required this.typePets,  
    this.imagePath,
  });
}
