import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/chechhealth_rec.dart';
import 'package:frontend/admin/event/chechhealth_rec.dart';
import 'package:frontend/admin/repositories/chechhealth_rec.dart';
import 'package:frontend/admin/state/chechhealth_rec.dart';
import 'package:frontend/admin/style/check_healthrec_style.dart';
import 'package:frontend/users/bloc/profile_bloc.dart';  
import 'package:frontend/users/state/profile_state.dart';
import 'package:intl/intl.dart';  

class HealthRecordScreen extends StatelessWidget {
  const HealthRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Health Record', style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 38, 111, 202),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HealthRecordBloc(HealthRecordRepository())..add(FetchHealthRecords()),
          ),
          // BlocProvider(
          //   create: (context) => ProfileBloc()..add(FetchProfile()),  // โหลดโปรไฟล์
          // ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'Check Health Record',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF263238),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<HealthRecordBloc, HealthRecordState>(
                builder: (context, state) {
                  if (state is HealthRecordLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HealthRecordLoaded) {
                    return BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, profileState) {
                        if (profileState is ProfileLoaded) {
                          return ListView.builder(
                            itemCount: state.healthRecords.length,
                            itemBuilder: (context, index) {
                              final record = state.healthRecords[index];
                              final profile = profileState.profile;
                              return Container(
                                width: 370,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: HealthStyles.containerBoxDecoration,
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 275,
                                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                color: Colors.amber,
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: profile.imageUrl != null
                                                          ? NetworkImage(profile.imageUrl!)
                                                          : null,
                                                      radius: 15,
                                                      child: profile.imageUrl == null
                                                          ? const Icon(Icons.person, size: 15)
                                                          : null,
                                                    ),
                                                    const SizedBox(width: 24),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "${profile.firstName} ${profile.lastName}",
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Text(profile.email,
                                                            style: const TextStyle(fontSize: 10, color: Colors.black)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                icon: HealthStyles.editIcon,
                                                iconSize: HealthStyles.iconSize,
                                                onPressed: () {
                                                  // Handle edit action
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Header: ${record.header}',
                                            style: HealthStyles.headerTextStyle,
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Age:',
                                            style: HealthStyles.healthTitleTextStyle,
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                'Start: ${formatAgeInYearsMonthsDays(record.age.years, record.age.months, record.age.days)}',
                                                style: HealthStyles.healthInfoTextStyle,
                                              ),
                                              const Spacer(),
                                              Text(
                                                'End: ${formatAgeInYearsMonthsDays(record.toAge.years, record.toAge.months, record.toAge.days)}',
                                                style: HealthStyles.healthInfoTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Weight:',
                                            style: HealthStyles.healthTitleTextStyle,
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                'Start: ${record.weightStartMonths} months',
                                                style: HealthStyles.healthInfoTextStyle,
                                              ),
                                              const Spacer(),
                                              Text(
                                                'End: ${record.weightEndMonths} months',
                                                style: HealthStyles.healthInfoTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            record.description,
                                            style: HealthStyles.healthInfoTextStyle,
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const Spacer(),
                                              Text(
                                                DateFormat('yyyy-MM-dd HH:mm:ss').format(record.recordDate),
                                                style: HealthStyles.healthInfoTextStyle,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else if (profileState is ProfileLoadFailure) {
                          return const Center(child: Text('Failed to load profile'));
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  } else if (state is HealthRecordError) {
                    return Center(child: Text(state.error));
                  }
                  return const Center(child: Text('No health records available.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatAgeInYearsMonthsDays(int years, int months, int days) {
    String result = '';
    if (years > 0) {
      result += '$years y ';
    }
    if (months > 0) {
      result += '$months m ';
    }
    result += '$days d';
    return result;
  }
}