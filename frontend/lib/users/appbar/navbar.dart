import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/notification.dart';
import 'package:frontend/users/event/notification.dart';
import 'package:frontend/users/repositories/notification.dart';
import 'package:frontend/users/state/notification.dart';

class NavbarUser extends StatelessWidget implements PreferredSizeWidget {
  const NavbarUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationUserBloc(
        notificationRepository: NotificationUserRepository(apiUrl: 'http://10.0.2.2:8000'),
      )..add(LoadNotificationsUser()),
      child: AppBar(
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(size: 32, color: Colors.white),
        title: const Text(
          'PET CARE',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, size: 32, color: Colors.white), 
                onPressed: () {
                  Navigator.pushNamed(context, '/notificationUser');
                },
              ),
              Positioned(
                right: 11,
                top: 11,
                child: BlocBuilder<NotificationUserBloc, NotificationUserState>(
                  builder: (context, state) {
                    int notificationCount = 0;

                    if (state is NotificationLoaded) {
                      final currentTime = DateTime.now().toLocal();
                      notificationCount = state.notifications.where((notification) {
                        return notification.startNoti.isBefore(currentTime) &&
                               notification.endNoti.isAfter(currentTime);
                      }).length;
                    }

                    return Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$notificationCount', 
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, size: 32, color: Colors.white), 
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
        toolbarHeight: 70,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
