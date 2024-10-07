import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/check_historyrec.dart';
import 'package:frontend/admin/event/check_historyrec.dart';
import 'package:frontend/admin/models/user.dart';
import 'package:frontend/admin/repositories/user_repository.dart';
import 'package:frontend/admin/state/check_historyrec.dart';
import 'package:frontend/admin/style/check_historyrec_style.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  TextEditingController _searchController = TextEditingController();
  Map<String, String> emailToFullName = {};

  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(FetchHistoryRecords());
    _loadUserProfiles();
  }

  Future<void> _loadUserProfiles() async {
    try {
      List<UserProfilePets> userProfiles = await UserRepository().getProfile();

      setState(() {
        emailToFullName = {
          for (var profile in userProfiles)
            profile.email: '${profile.firstName} ${profile.lastName}',
        };
      });
    } catch (e) {
      print('Failed to load user profiles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("History Records", style: appBarTitleTextStyle),
        backgroundColor: primaryColor,
        centerTitle: true,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Text("Check History", style: headerTextStyle),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, size: 15),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 24),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    hintText: 'Search',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HistoryLoaded) {
                  String searchTerm = _searchController.text.toLowerCase();

                  // ข้อมูลที่ใช้แสดง Check History
                  final filteredRecords = state.historyRecords.where((record) {
                    return record.header.toLowerCase().contains(searchTerm) ||
                        record.symptoms.toLowerCase().contains(searchTerm) ||
                        record.diagnose.toLowerCase().contains(searchTerm) ||
                        record.remark.toLowerCase().contains(searchTerm) ||
                        record.petName.toLowerCase().contains(searchTerm) ||
                        record.ownerName.toLowerCase().contains(searchTerm) ||
                        record.noteBy.toLowerCase().contains(searchTerm);
                  }).toList();

                  if (filteredRecords.isEmpty) {
                    return const Center(
                        child: Text('No history records found.'));
                  }

                  final displayedPets = <String>{};

                  return ListView.builder(
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = filteredRecords[index];

                      if (displayedPets.contains(record.petName)) {
                        return const SizedBox.shrink();
                      }

                      displayedPets.add(record.petName);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Owner Profile
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.person,
                                        size: 40, color: Colors.blue),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    record.ownerName,
                                    style: ownerNameTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              // Pet Name and History Details
                              Container(
                                decoration: vaccineInfoBoxDecoration,
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Pet Name
                                    Center(
                                      child: Text(
                                        'Name: ${record.petName}',
                                        style: petNameTextStyle,
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    ...filteredRecords
                                        .where(
                                            (r) => r.petName == record.petName)
                                        .map((historyRecord) {
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd').format(
                                              historyRecord.recordDatetime
                                                  .toLocal());

                                      String fullName = emailToFullName[
                                              historyRecord.noteBy] ??
                                          historyRecord.noteBy;

                                      return Container(
                                        margin: const EdgeInsets.only(top: 8.0),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Date
                                            Container(
                                              width: double.infinity,
                                              decoration: dateBoxDecoration,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              child: Text(
                                                'Date: $formattedDate',
                                                style: dateContainerTextStyle,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            // Note by
                                            Container(
                                              width: double.infinity,
                                              decoration: noteBoxDecoration,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(Icons.note_alt,
                                                      size: 16,
                                                      color: Colors.white),
                                                  const SizedBox(width: 5),
                                                  Flexible(
                                                    child: Text(
                                                      'Note by: $fullName',
                                                      style:
                                                          dateContainerTextStyle,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      style: regularTextStyle,
                                                      children: [
                                                        const TextSpan(
                                                          text: 'Header: ',
                                                          style: boldTextStyle,
                                                        ),
                                                        TextSpan(
                                                          text: historyRecord
                                                              .header,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  RichText(
                                                    text: TextSpan(
                                                      style: regularTextStyle,
                                                      children: [
                                                        const TextSpan(
                                                          text: 'Symptoms: ',
                                                          style: boldTextStyle,
                                                        ),
                                                        TextSpan(
                                                          text: historyRecord
                                                              .symptoms,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  RichText(
                                                    text: TextSpan(
                                                      style: regularTextStyle,
                                                      children: [
                                                        const TextSpan(
                                                          text: 'Diagnose: ',
                                                          style: boldTextStyle,
                                                        ),
                                                        TextSpan(
                                                          text: historyRecord
                                                              .diagnose,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  RichText(
                                                    text: TextSpan(
                                                      style: regularTextStyle,
                                                      children: [
                                                        const TextSpan(
                                                          text: 'Remark: ',
                                                          style: boldTextStyle,
                                                        ),
                                                        TextSpan(
                                                          text: historyRecord
                                                              .remark,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),

                                    // Add Record button
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      style: elevatedButtonStyle,
                                      onPressed: () async {
                                        final result =
                                            await Navigator.of(context)
                                                .pushNamed('/addhistoryrec');

                                        if (result != null && result == true) {
                                          context
                                              .read<HistoryBloc>()
                                              .add(FetchHistoryRecords());
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16.0),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF90C8AC),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Text(
                                              'Add Record',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is HistoryError) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                return const Center(child: Text('No history records found'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
