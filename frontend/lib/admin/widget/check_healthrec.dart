import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/chechhealth_rec.dart';
import 'package:frontend/admin/event/chechhealth_rec.dart';
import 'package:frontend/admin/repositories/chechhealth_rec.dart';
import 'package:frontend/admin/state/chechhealth_rec.dart';

class HealthRecordScreen extends StatelessWidget {
  const HealthRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Record'),
      ),
      body: BlocProvider(
        create: (context) => HealthRecordBloc(HealthRecordRepository())..add(FetchHealthRecords()),
        child: BlocBuilder<HealthRecordBloc, HealthRecordState>(
          builder: (context, state) {
            if (state is HealthRecordLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HealthRecordLoaded) {
              return ListView.builder(
                itemCount: state.healthRecords.length,
                itemBuilder: (context, index) {
                  final record = state.healthRecords[index];
                  return Card(
                    child: ListTile(
                      title: Text(record.header), 
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pet Type: ${record.petType}'), 
                          Text('Age: ${record.age.months} months to ${record.toAge.months} months'),
                          Text('Weight Start: ${record.weightStartMonths} months'),
                          Text('Weight End: ${record.weightEndMonths} months'),
                          Text('Description: ${record.description}'),
                          Text('Record Date: ${record.recordDate.toString()}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is HealthRecordError) {
              return Center(child: Text(state.error));
            }

            return const Center(child: Text('No health records available.'));
          },
        ),
      ),
    );
  }
}
