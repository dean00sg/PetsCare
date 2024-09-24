import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/add_notification.dart';
import 'package:frontend/admin/event/add_notification.dart';
import 'package:frontend/admin/state/add_notification.dart';
import 'package:frontend/users/bloc/profile_bloc.dart';
import 'package:frontend/users/state/profile_state.dart';
import 'package:intl/intl.dart';

class AddNotificationScreen extends StatefulWidget {
  const AddNotificationScreen({super.key});

  @override
  _AddNotificationScreenState createState() => _AddNotificationScreenState();
}

class _AddNotificationScreenState extends State<AddNotificationScreen> {
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String? _toUser;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AddNotificationBloc>(context)
        .add(LoadUsersForNotification());
    BlocProvider.of<ProfileBloc>(context).loadProfile();
  }

  Future<void> _selectDateTime(
      BuildContext context, TextEditingController controller,
      {required bool isStartDate}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStartDate) {
            _startDate = fullDateTime;
          } else {
            _endDate = fullDateTime;
          }
          controller.text = DateFormat('yyyy-MM-dd HH:mm').format(fullDateTime);
        });
      }
    }
  }

  void _resetForm() {
    setState(() {
      _headerController.clear();
      _detailController.clear();
      _imageUrlController.clear();
      _startDateController.clear();
      _endDateController.clear();
      _startDate = null;
      _endDate = null;
      _toUser = null;
  });

  BlocProvider.of<AddNotificationBloc>(context).add(LoadUsersForNotification());
}

  // ฟังก์ชันแสดง pop-up เมื่อกดปุ่ม Save
  void _showSaveDialog(BuildContext context) {
    final profileState = BlocProvider.of<ProfileBloc>(context).state;
    final fromUser = (profileState is ProfileLoaded)
        ? profileState.profile.email
        : 'Unknown';
    final toUser = _toUser ?? 'Unknown';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 300, // ปรับขนาดของ pop-up
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Add Notification Success',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // ใช้ RichText เพื่อจัดแสดง header
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Header: ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: _headerController.text,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text('Sent by: $fromUser'),
                const SizedBox(height: 10),
                Text('Sent to: $toUser'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ปุ่ม Cancel
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // ปุ่ม Sent
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        //Navigator.of(context).pop(); // ปิด pop-up
                        _submitNotification(
                            context); // ส่งข้อมูลหลังจากกดปุ่ม Sent
                      },
                      child: const Text(
                        'Sent',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ฟังก์ชันบันทึกข้อมูลหลังจากกด Sent
void _submitNotification(BuildContext context) {
  if (_toUser != null &&
      _headerController.text.isNotEmpty &&
      _startDate != null &&
      _endDate != null &&
      _imageUrlController.text.isNotEmpty) {
    //ทำการบันทึกข้อมูล
    context.read<AddNotificationBloc>().add(
          AddNotificationSubmitted(
            header: _headerController.text,
            toUser: _toUser!,
            startNoti: _startDate!,
            endNoti: _endDate!,
            file: _imageUrlController.text,
            detail: _detailController.text,
          ),
        );

    _resetForm(); // Reset the form, including the 'To User' field
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill out all fields')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Notification",
            style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 38, 111, 202),
        centerTitle: true,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<AddNotificationBloc, AddNotificationState>(
        listener: (context, state) {
          if (state is AddNotificationSuccess) {
            // ปิด pop-up เมื่อส่งข้อมูลสำเร็จ
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notification sent successfully!')),
            );
          } else if (state is AddNotificationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "Add Notification",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 38, 111, 202),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        if (state is ProfileLoaded) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: state.profile.imageUrl !=
                                          null
                                      ? NetworkImage(state.profile.imageUrl!)
                                      : null,
                                  radius: 30,
                                  child: state.profile.imageUrl == null
                                      ? const Icon(Icons.person, size: 30)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${state.profile.firstName} ${state.profile.lastName}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(state.profile.email,
                                        style: const TextStyle(
                                            color: Colors.black)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else if (state is ProfileLoadFailure) {
                          return const Text('Failed to load profile');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("To User:",
                        style: TextStyle(color: Colors.white)),
                    BlocBuilder<AddNotificationBloc, AddNotificationState>(
                      builder: (context, state) {
                        if (state is UsersLoadedForNotification) {
                          final userPetsList = state.users
                              .where((user) => user.role == 'userpets')
                              .toList();
                          return DropdownButtonFormField<String>(
                            value: _toUser,
                            onChanged: (value) =>
                                setState(() => _toUser = value),
                            items: userPetsList.map((user) {
                              return DropdownMenuItem(
                                value: user.email,
                                child: Text(user.email),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFDDF3FF),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          );
                        } else if (state is AddNotificationLoading) {
                          return const CircularProgressIndicator();
                        } else {
                          return const Text("Failed to load users");
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("Header:",
                        style: TextStyle(color: Colors.white)),
                    TextField(
                      controller: _headerController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFDDF3FF),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Image URL:",
                        style: TextStyle(color: Colors.white)),
                    TextField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFDDF3FF),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Start DateTime:",
                        style: TextStyle(color: Colors.white)),
                    TextField(
                      controller: _startDateController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFDDF3FF),
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      readOnly: true,
                      onTap: () => _selectDateTime(
                          context, _startDateController,
                          isStartDate: true),
                    ),
                    const SizedBox(height: 16),
                    const Text("End DateTime:",
                        style: TextStyle(color: Colors.white)),
                    TextField(
                      controller: _endDateController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFDDF3FF),
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      readOnly: true,
                      onTap: () => _selectDateTime(context, _endDateController,
                          isStartDate: false),
                    ),
                    const SizedBox(height: 16),
                    const Text("Detail:",
                        style: TextStyle(color: Colors.white)),
                    TextField(
                      controller: _detailController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFDDF3FF),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          _showSaveDialog(context); // แสดง pop-up เมื่อกด Save
                        },
                        child:
                            const Text("Save", style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
