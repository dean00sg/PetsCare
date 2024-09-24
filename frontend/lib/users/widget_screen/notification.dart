import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/appbar/search_bar.dart';
import 'package:frontend/users/bloc/notification.dart';
import 'package:frontend/users/event/notification.dart';
import 'package:frontend/users/repositories/notification.dart';
import 'package:frontend/users/state/notification.dart';
import 'package:frontend/users/styles/notification_style.dart';
import 'package:intl/intl.dart';

class NotificationUser extends StatelessWidget {
  const NotificationUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationUserBloc(
        notificationRepository: NotificationUserRepository(apiUrl: 'http://10.0.2.2:8000'),
      )..add(LoadNotificationsUser()),
      child: const Scaffold(
 
        body: NotificationScreen(),
      ),
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
    String searchQuery = '';

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Notification', style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: Colors.brown,
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 290,
                  child: CustomSearchBar(
                    onChanged: (value) {
                      searchQuery = value;
                      BlocProvider.of<NotificationUserBloc>(context).add(LoadNotificationsUser());
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: NotificationStyles.deleteButtonDecoration,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      // Action for delete button
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<NotificationUserBloc, NotificationUserState>(
              builder: (context, state) {
                if (state is NotificationLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NotificationLoaded) {
                  final currentTime = DateTime.now().toLocal();
                  final filteredNotifications = state.notifications.where((notification) {
                    final isInTimeRange = notification.startNoti.isBefore(currentTime) && notification.endNoti.isAfter(currentTime);
                    final matchesSearchQuery = notification.detail.toLowerCase().contains(searchQuery.toLowerCase()) ||
                                                notification.userName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                                                notification.createname.toLowerCase().contains(searchQuery.toLowerCase());
                    return isInTimeRange && matchesSearchQuery;
                  }).toList();

                  // จำนวนการ์ดที่กรอง
                  final notificationCount = filteredNotifications.length;

                  if (notificationCount == 0) {
                    return const Center(child: Text('No Notifications'));
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$notificationCount Notifications',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: notificationCount,
                          itemBuilder: (context, index) {
                            final notification = filteredNotifications[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                              color: Colors.brown[400],
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 20,
                                          child: Icon(Icons.person, color: Colors.grey),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          notification.createname,
                                          style: NotificationStyles.titleStyle,
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.close, color: Colors.white),
                                          onPressed: () {
                                            BlocProvider.of<NotificationUserBloc>(context).add(DeleteNotificationUser(notification.notiId));
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'By: ${notification.createBy}',
                                      style: NotificationStyles.subtitleStyle,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'To: ${notification.toUser}',
                                      style: NotificationStyles.subtitleStyle,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Dear ${notification.userName}',
                                      style: NotificationStyles.titleStyle,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      notification.header,
                                      style: NotificationStyles.headerStyle,
                                    ),


                                    //imageUrl
                                    if (notification.file.isNotEmpty) ...[
                                      const SizedBox(height: 10),
                                      Image.network(
                                        notification.file,
                                        fit: BoxFit.cover, // Fit the image
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Text('Image not available');
                                        },
                                      ),
                                    ],


                                    const SizedBox(height: 5),
                                    Text(
                                      notification.detail,
                                      style: NotificationStyles.detailStyle,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Spacer(),
                                        Text(
                                          formatDateTime(notification.recordDatetime),
                                          style: const TextStyle(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is NotificationUserError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('No Notifications'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
