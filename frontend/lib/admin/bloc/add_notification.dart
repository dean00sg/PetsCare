import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/add_notification.dart';
import 'package:frontend/admin/models/add_notification.dart';
import 'package:frontend/admin/models/user.dart';
import 'package:frontend/admin/repositories/add_notification.dart';
import 'package:frontend/admin/state/add_notification.dart';

class AddNotificationBloc extends Bloc<AddNotificationEvent, AddNotificationState> {
  final AddNotificationUserRepository notificationRepository;
  final UserListRepository userListRepository;

  List<UserProfilePets>? users;

  AddNotificationBloc({
    required this.notificationRepository,
    required this.userListRepository,
  }) : super(AddNotificationInitial()) {
  
    // Loading the list of users
    on<LoadUsersForNotification>((event, emit) async {
      emit(AddNotificationLoading());
      try {
        users = await _loadUsers();
        emit(UsersLoadedForNotification(users: users!));
      } catch (e) {
        emit(AddNotificationFailure(error: e.toString()));
      }
    });

    // Submitting the notification
    on<AddNotificationSubmitted>((event, emit) async {
      emit(AddNotificationLoading());
      try {
        final notification = AddNotificationUserModel(
          notiId: 0,
          header: event.header,
          toUser: event.toUser,
          userName: '',  // To be filled based on the current user's data
          recordDatetime: DateTime.now(),
          startNoti: event.startNoti,
          endNoti: event.endNoti,
          file: event.file,
          detail: event.detail,
          createBy: '', // To be set based on your logic
          createname: '', // To be set based on your logic
        );
        await notificationRepository.postNotification(notification);
        emit(AddNotificationSuccess());
      } catch (e) {
        emit(AddNotificationFailure(error: e.toString()));
      }
    });
  }

  // Fetching the list of users from the repository
  Future<List<UserProfilePets>> _loadUsers() async {
    try {
      final List<UserProfilePets> users = await userListRepository.getProfile();
      return users;
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }
}
