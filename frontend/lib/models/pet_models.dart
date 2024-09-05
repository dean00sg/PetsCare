
class Pet {
  final String name;
  final String imagePath;

  Pet({required this.name, required this.imagePath});
}

final List<Pet> pets = [
  Pet(name: 'Cat', imagePath: 'lib/images/cat_icon.png'),
  Pet(name: 'Dog', imagePath: 'lib/images/dog_icon.png'),
  Pet(name: 'Rabbit', imagePath: 'lib/images/rabbit_icon.png'),
  Pet(name: 'Fish', imagePath: 'lib/images/fish_icon.png'),
];
