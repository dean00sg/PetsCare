
class Pet {
  final String name;
  final String imagePath;

  Pet({required this.name, required this.imagePath});
}

final List<Pet> pets = [
  Pet(name: 'CAT', imagePath: 'lib/images/cat_icon.png'),
  Pet(name: 'DOG', imagePath: 'lib/images/dog_icon.png'),
  Pet(name: 'RABBIT', imagePath: 'lib/images/rabbit_icon.png'),
  Pet(name: 'FISH', imagePath: 'lib/images/fish_icon.png'),
];
