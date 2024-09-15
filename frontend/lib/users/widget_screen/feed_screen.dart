import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/feed_bloc.dart';
import '../event/feed_event.dart';
import '../state/feed_state.dart';
import '../models/feed_model.dart';
import '../repositories/feed_repository.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text('PET CARE', style: TextStyle(fontSize: 16, color: Colors.white)),
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
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown[400],
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('PETS'),
              onTap: () {
                Navigator.pushNamed(context, '/pet');
              },
            ),
            ListTile(
              title: const Text('My Pets'),
              onTap: () {
                // Handle tap
              },
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) => FeedBloc(feedRepository: FeedRepository(apiUrl: 'http://127.0.0.1:8000'))..add(FetchFeedData()),
        child: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            if (state is FeedLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FeedLoaded) {
              return ListView.builder(
                itemCount: state.feedPosts.length,
                itemBuilder: (context, index) {
                  FeedPost post = state.feedPosts[index];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.header,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            if (post.imageUrl != null)
                              Image.network(
                                post.imageUrl!,
                                fit: BoxFit.cover,
                                height: 200, // Adjust height as needed
                                width: double.infinity, // Make image full width
                              ),
                            const SizedBox(height: 8),
                            Text(
                              post.description ?? 'No description available',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is FeedError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No articles available.'));
            }
          },
        ),
      ),
    );
  }
}
