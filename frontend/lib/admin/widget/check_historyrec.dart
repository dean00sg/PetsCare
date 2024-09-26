import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/check_historyrec.dart';
import 'package:frontend/admin/event/check_historyrec.dart';
import 'package:frontend/admin/repositories/historyrec.dart';
import 'package:frontend/admin/state/check_historyrec.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History Records"),
      ),
      body: BlocProvider(
        create: (context) =>
            HistoryBloc(repository: HistoryRepository(apiUrl: 'http://10.0.2.2:8000'))
              ..add(FetchHistoryRecords()),
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HistoryLoaded) {
              return ListView.builder(
                itemCount: state.historyRecords.length,
                itemBuilder: (context, index) {
                  final record = state.historyRecords[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Header: ${record.header}", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text("Record Date: ${record.recordDatetime.toLocal()}"),
                          const SizedBox(height: 8),
                          Text("Symptoms: ${record.symptoms}"),
                          const SizedBox(height: 8),
                          Text("Diagnose: ${record.diagnose}"),
                          const SizedBox(height: 8),
                          Text("Remark: ${record.remark}"),
                          const SizedBox(height: 8),
                          Text("Pet Name: ${record.petName}"),
                          const SizedBox(height: 8),
                          Text("Owner Name: ${record.ownerName}"),
                          const SizedBox(height: 8),
                          Text("Noted By: ${record.noteBy}"),
                          const SizedBox(height: 8),
                          Text("History Record ID: ${record.hrId}"),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is HistoryError) {
              return Center(child: Text(state.error));
            } else {
              return const Center(child: Text("No history records found"));
            }
          },
        ),
      ),
    );
  }
}
