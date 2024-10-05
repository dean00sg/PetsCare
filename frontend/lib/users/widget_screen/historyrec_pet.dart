import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/historyrec_pet.dart';
import 'package:frontend/users/event/historyrec_pet.dart';
import 'package:frontend/users/state/historyrec_pet.dart';
import 'package:frontend/users/styles/petprofile_style.dart';
import 'package:intl/intl.dart';

class HistoryRecUserScreen extends StatelessWidget {
  const HistoryRecUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final petsId = arguments['petsId'] as int;
    final petName = arguments['name'] as String;
    final imagePath = arguments['image'] as String;

    context
        .read<HistoryRecUserBloc>()
        .add(LoadHistoryRecUser(petsId.toString()));

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: PetProfileStyles.appBarBackgroundColor,
        centerTitle: true,
        toolbarHeight: 70,
        title: const Text(
          'History Record',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                16.0,
                MediaQuery.of(context).size.width * 0.05,
                0.0,
              ),
              // Pet Name Container
              child: Container(
                width: double.infinity,
                color: const Color(0xFF41A785),
                height: 80,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      // Pet Profile Image
                      radius: 25,
                      backgroundImage: AssetImage(imagePath),
                    ),
                    Text(
                      ' $petName',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                0.0,
                MediaQuery.of(context).size.width * 0.05,
                16.0,
              ),
              child: Container(
                width: double.infinity,
                color: const Color(0xFF98D9B8), // Main container for history
                child: BlocBuilder<HistoryRecUserBloc, HistoryRecUserState>(
                  builder: (context, state) {
                    if (state is HistoryRecUserLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is HistoryRecUserError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is HistoryRecUserLoaded) {
                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.records.length,
                            itemBuilder: (context, index) {
                              final record = state.records[index];
                              return _buildHistoryContainer(record);
                            },
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: Text('No records found.'));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryContainer(record) {
    final formattedDate = DateFormat('yyyy-MM-dd')
        .format(record.recordDateTime);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white, //Container of history information
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), 
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Date Container
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 9, 154, 132), 
            ),
            child: Text(
              'Date: $formattedDate',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          //Note Name Container
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 100, 150, 230), 
            ),
            child: Text(
              'Note Name: ${record.noteName}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          //Main information container 
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Header: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        record.header,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Symptoms: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        record.symptoms,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Diagnose: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        record.diagnose,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Remark: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        record.remark,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
