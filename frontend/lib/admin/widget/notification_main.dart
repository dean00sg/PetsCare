// widgets/notification_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/notification_main.dart';
import 'package:frontend/admin/event/notification_main.dart';
import 'package:frontend/admin/state/notification_main.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 38, 111, 202), // Consistent AppBar style
        title: const Text(
          'Admin',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (String result) {
              if (result == 'profile') {
                Navigator.pushNamed(context, '/profile');
              } else if (result == 'signout') {
                Navigator.pushNamed(context, '/');
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('PROFILE'),
              ),
              const PopupMenuItem<String>(
                value: 'signout',
                child: Text('SIGN OUT'),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 38, 111, 202),
              ),
              child: Text(
                'Admin Service',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Check Info'),
              onTap: () {
                Navigator.pushNamed(context, '/pet');
              },
            ),
            ListTile(
              title: const Text('Add Notification'),
              onTap: () {
                // Handle tap
              },
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (_) => NotificationBloc(),
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notification',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Add Notification Button
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/addfeedpost');
                          BlocProvider.of<NotificationBloc>(context).add(AddNotificationEvent());
                        },
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.notifications, size: 50, color: Colors.white),
                              SizedBox(height: 10),
                              Text(
                                'Add FeedPost',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Add News Feed Advice Button
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<NotificationBloc>(context).add(AddNewsFeedAdviceEvent());
                        },
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.article, size: 50, color: Colors.white),
                              SizedBox(height: 10),
                              Text(
                                'Add News Feed Advice',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Display state updates (if needed)
                  if (state is NotificationAddedState)
                    const Text('Notification added!'),
                  if (state is NewsFeedAdviceAddedState)
                    const Text('News Feed Advice added!'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
