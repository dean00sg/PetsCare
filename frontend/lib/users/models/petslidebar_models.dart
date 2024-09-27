class Pet {
  final int petsId;
  final String name;
  final String imagePath;

  Pet({required this.petsId,required this.name, required this.imagePath});
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
