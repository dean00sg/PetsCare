import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/vaccination.dart';
import 'package:frontend/admin/event/vaccination.dart';
import 'package:frontend/admin/state/vaccination.dart';
import 'package:intl/intl.dart';
import '../style/check_vaccination_style.dart';

class PetVacProfilesScreen extends StatefulWidget {
  const PetVacProfilesScreen({super.key});

  @override
  _PetVacProfilesScreenState createState() => _PetVacProfilesScreenState();
}

class _PetVacProfilesScreenState extends State<PetVacProfilesScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PetVacBloc>().add(FetchPetVacProfiles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Pet Vaccines", style: appBarTitleTextStyle),
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
        //Header Section
          Container(
            width: double.infinity, 
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, 
              children: [
                Text(
                  "Check History",
                  style: headerTextStyle,
                ),
              ],
            ),
          ),

          //Search Bar
          Container(
            decoration: searchBarDecoration,
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
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 15,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 24,
                            ),
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
            child: BlocBuilder<PetVacBloc, PetVacState>(
              builder: (context, state) {
                if (state is PetVacLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PetVacLoaded) {
                  String searchTerm = _searchController.text.toLowerCase();

                  //ข้อมูลที่ใช้แสดง
                  final filteredProfiles = state.profiles.where((profile) {
                    return profile.petName.toLowerCase().contains(searchTerm) ||
                        profile.ownerName.toLowerCase().contains(searchTerm) ||
                        profile.vacName.toLowerCase().contains(searchTerm) ||
                        profile.location.toLowerCase().contains(searchTerm) ||
                        profile.remark.toLowerCase().contains(searchTerm) ||
                        profile.note_by.toLowerCase().contains(searchTerm);
                  }).toList();

                  if (filteredProfiles.isEmpty) {
                    return const Center(
                        child: Text('No vaccination profiles found.'));
                  }

                  final displayedPets = <String>{};

                  return ListView.builder(
                    itemCount: filteredProfiles.length,
                    itemBuilder: (context, index) {
                      final profile = filteredProfiles[index];

                      if (displayedPets.contains(profile.petName)) {
                        return const SizedBox.shrink();
                      }

                      displayedPets.add(profile.petName);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: Container(
                          width: double.infinity,
                          decoration: profileContainerDecoration,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Profile display
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
                                    '${profile.ownerName}',
                                    style: profileNameTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              //Pet Name and Vaccination Details
                              Container(
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Pet Name
                                    Center(
                                      child: Text(
                                        'Name: ${profile.petName}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    //vaccination profiles for each pet
                                    ...filteredProfiles
                                        .where(
                                            (p) => p.petName == profile.petName)
                                        .map((vaccineProfile) {
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd').format(
                                              vaccineProfile.startDateVac);

                                      return Container(
                                        margin: const EdgeInsets.only(top: 8.0),
                                        decoration: vaccineContainerDecoration,
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //Vaccination Header and Note by
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                //Date 
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration:
                                                      dateContainerDecoration,
                                                  child: Text(
                                                    'Date: $formattedDate',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),

                                                //Note 
                                                Flexible(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    decoration:
                                                        noteByContainerDecoration,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                            Icons.note_alt,
                                                            size: 16,
                                                            color:
                                                                Colors.white),
                                                        const SizedBox(
                                                            width: 5),
                                                        Flexible(
                                                          child: Text(
                                                            'Note by: ${vaccineProfile.note_by}',
                                                            style:
                                                                noteByTextStyle,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),

                                            //Vaccine Information 
                                            RichText(
                                              text: TextSpan(
                                                style: formTextStyle,
                                                children: [
                                                  const TextSpan(
                                                    text: 'Vaccine Name: ',
                                                    style: boldFormTextStyle,
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        vaccineProfile.vacName,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),

                                            RichText(
                                              text: TextSpan(
                                                style: formTextStyle,
                                                children: [
                                                  const TextSpan(
                                                    text: 'Location: ',
                                                    style: boldFormTextStyle,
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        vaccineProfile.location,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),

                                            RichText(
                                              text: TextSpan(
                                                style: formTextStyle,
                                                children: [
                                                  const TextSpan(
                                                    text: 'Remark: ',
                                                    style: boldFormTextStyle,
                                                  ),
                                                  TextSpan(
                                                    text: vaccineProfile.remark,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),

                                    //Add Vaccine button
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      style: elevatedButtonStyle,
                                      onPressed: () async {
                                        final result =
                                            await Navigator.of(context)
                                                .pushNamed('/addvaccination');

                                        if (result != null && result == true) {
                                          context
                                              .read<PetVacBloc>()
                                              .add(FetchPetVacProfiles());
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              decoration: const BoxDecoration(
                                                color: secondaryColor,
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
                                              'Add Vaccine',
                                              style: buttonTextStyle,
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
                } else if (state is PetVacError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const Center(
                    child: Text('No vaccination profiles available.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}