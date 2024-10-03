import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/historyrec_pet.dart';
import 'package:frontend/users/event/historyrec_pet.dart';
import 'package:frontend/users/state/historyrec_pet.dart';

class HistoryRecUserScreen extends StatelessWidget {
  const HistoryRecUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final petsId = arguments['petsId'] as int;
    final petName = arguments['name'] as String;
    final imagePath = arguments['image'] as String;

    // Dispatch event to load history records
    context.read<HistoryRecUserBloc>().add(LoadHistoryRecUser(petsId.toString()));

    return Scaffold(
      appBar: AppBar(
        title: Text('History of $petName'),
      ),
      body: BlocBuilder<HistoryRecUserBloc, HistoryRecUserState>(
        builder: (context, state) {
          if (state is HistoryRecUserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryRecUserLoaded) {
            final records = state.records;
            return ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(imagePath), // Displaying the image
                      radius: 30, // Adjust the radius as needed
                    ),
                    title: Text(record.header),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pet Name: ${record.petName}'),
                        Text('Owner: ${record.ownerName}'),
                        Text('Symptoms: ${record.symptoms}'),
                        Text('Diagnose: ${record.diagnose}'),
                        Text('Remark: ${record.remark}'),
                        Text('Note By: ${record.noteBy}'),
                        Text('Note Name: ${record.noteName}'),
                        Text('Date: ${record.recordDateTime.toString()}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is HistoryRecUserError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No records found.'));
          }
        },
      ),
    );
  }
}
