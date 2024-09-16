// widgets/feed_post_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/add_feedpost.dart';
import 'package:frontend/admin/event/add_feedpost.dart';
import 'package:frontend/admin/models/add_feedpost.dart';
import 'package:frontend/admin/state/add_feedpost.dart';

class FeedPostWidget extends StatefulWidget {
  const FeedPostWidget({super.key});

  @override
  _FeedPostWidgetState createState() => _FeedPostWidgetState();
}

class _FeedPostWidgetState extends State<FeedPostWidget> {
  final _formKey = GlobalKey<FormState>();
  String header = '';
  DateTime startDatetime = DateTime.now();
  DateTime endDatetime = DateTime.now();
  String imageUrl = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 38, 111, 202), 
        title: const Text('Admin', style: TextStyle(fontSize: 16, color: Colors.white)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<FeedBloc, FeedState>(
          listener: (context, state) {
            if (state is FeedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feed post added successfully')));
            } else if (state is FeedFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add post: ${state.error}')));
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('FeedPost', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Header'),
                  onChanged: (value) => setState(() => header = value),
                  validator: (value) => value!.isEmpty ? 'Please enter a header' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Start DateTime'),
                  onChanged: (value) => setState(() => startDatetime = DateTime.parse(value)),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'End DateTime'),
                  onChanged: (value) => setState(() => endDatetime = DateTime.parse(value)),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  onChanged: (value) => setState(() => imageUrl = value),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onChanged: (value) => setState(() => description = value),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final post = FeedPost(
                        header: header,
                        startDatetime: startDatetime,
                        endDatetime: endDatetime,
                        imageUrl: imageUrl,
                        description: description,
                      );
                      BlocProvider.of<FeedBloc>(context).add(AddFeedPostEvent(post));
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
