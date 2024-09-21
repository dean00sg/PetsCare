import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/notification.dart';
import 'package:frontend/users/event/notification.dart';
import 'package:frontend/users/repositories/notification.dart';
import 'package:frontend/users/state/notification.dart';
import 'package:intl/intl.dart';

class NotificationUser extends StatelessWidget {
  const NotificationUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationUserBloc(
        notificationRepository: NotificationUserRepository(apiUrl: 'http://10.0.2.2:8000'),
      )..add(LoadNotificationsUser()),
      child: const NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Notification', style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: Colors.brown,
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: BlocBuilder<NotificationUserBloc, NotificationUserState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            final currentTime = DateTime.now().toLocal();
            final filteredNotifications = state.notifications.where((notification) {
              return notification.startNoti.isBefore(currentTime) && notification.endNoti.isAfter(currentTime);
            }).toList();

            if (filteredNotifications.isEmpty) {
              return const Center(child: Text('No Notifications'));
            }

            return ListView.builder(
              itemCount: filteredNotifications.length,
              itemBuilder: (context, index) {
                final notification = filteredNotifications[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  color: Colors.brown[400],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.brown,
                              radius: 20,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              notification.createname,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'By: ${notification.createBy}',
                              style: const TextStyle(fontSize: 12, color: Colors.white70),
                            ),
                            Text(
                              'To: ${notification.toUser}',
                              style: const TextStyle(fontSize: 12, color: Colors.white70),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 10),
                        
                       
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            formatDateTime(notification.recordDatetime),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                        
                        Text(
                          'Dear ${notification.userName}', 
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        
                       
                        Text(
                          notification.detail,
                          style: const TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        
                        const SizedBox(height: 10),
                        
               
                        
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is NotificationUserError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No Notifications'));
          }
        },
      ),
    );
  }
}
