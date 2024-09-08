// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:frontend/users/models/signup_model.dart';
// import 'package:frontend/users/widget_screen/edit_profile_user.dart';
// import 'package:frontend/users/styles/profile_style.dart'; // นำเข้าไฟล์สไตล์

// class ProfileUser extends StatefulWidget {
//   final SignupModel userData;

//   const ProfileUser({super.key, required this.userData});

//   @override
//   _ProfileUserState createState() => _ProfileUserState();
// }

// class _ProfileUserState extends State<ProfileUser> {
//   late SignupModel currentUserData;
//   File? _profileImage;

//   @override
//   void initState() {
//     super.initState();
//     currentUserData = widget.userData;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.brown[400],
//         title: const Text('PROFILE', style: TextStyle(fontSize: 16, color: Colors.white)),
//         centerTitle: true,
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.brown[400],
//               ),
//               child: const Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               title: const Text('FEED'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/feed');
//               },
//             ),
//             ListTile(
//               title: const Text('PETS'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/pet');
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 16),
//               GestureDetector(
//                 onTap: () {},
//                 child: CircleAvatar(
//                   radius: avatarRadius,
//                   backgroundImage: _profileImage != null
//                       ? FileImage(_profileImage!)
//                       : const AssetImage('lib/images/logo.png') as ImageProvider,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 '${currentUserData.firstName} ${currentUserData.lastName}',
//                 style: nameTextStyle,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   final result = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => EditProfileScreen(userData: currentUserData),
//                     ),
//                   );

//                   if (result != null) {
//                     setState(() {
//                       currentUserData = result['userData'];
//                       _profileImage = result['profileImage'];
//                     });
//                   }
//                 },
//                 icon: const Icon(Icons.edit),
//                 label: const Text('Edit Profile'),
//                 style: editButtonStyle,
//               ),
//               const SizedBox(height: 16),
//               // Container ที่คลุม Text และใส่สีน้ำตาล
//               Container(
//                 width: 300,
//                 height: 150,
//                 margin: const EdgeInsets.symmetric(vertical: 16),
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: containerDecoration,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start, 
//                   children: [
//                     const SizedBox(height: 8),
//                     Text(
//                       'Email: ${currentUserData.email}',
//                       style: infoTextStyle,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Phone: ${currentUserData.phone}',
//                       style: infoTextStyle,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 width: 300,
//                 height: 70,
//                 margin: const EdgeInsets.symmetric(vertical: 16),
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: containerDecoration, 
//                 child: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Mypets',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.white,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 style: signoutButtonStyle,
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/');
//                 },
//                 child: const Text('SIGN OUT', style: TextStyle(fontSize: 16)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
