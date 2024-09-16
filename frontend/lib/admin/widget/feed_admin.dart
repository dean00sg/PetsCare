import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/users/bloc/feed_bloc.dart';
import 'package:frontend/users/event/feed_event.dart';
import 'package:frontend/users/models/feed_model.dart';
import 'package:frontend/users/repositories/feed_repository.dart';
import 'package:frontend/users/state/feed_state.dart';


class FeedadminScreen extends StatelessWidget {
  const FeedadminScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 38, 111, 202),
        title: const Text(
          'Admin',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
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
              return Container(
                color: Colors.white,  // Set the background color of the body to white
                child: ListView.builder(
                  itemCount: state.feedPosts.length + 1,  // +1 for the welcome section
                  itemBuilder: (context, index) {
                    // Welcome section inside ListView.builder
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'lib/images/logo.png',  // Your logo path
                              height: 170,             // Set the height
                              width: 170,              // Set the width
                              fit: BoxFit.contain,      // Control how the image fits within the space
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'WELCOME TO PET CARE',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'รู้หรือไม่ว่ามีการดูแลสัตว์เลี้ยงให้มีชีวิตยาวนานอย่างเหมาะสมด้วยการดูแลสุขภาพ เช็คโปรโมชันสำหรับสินค้าเกี่ยวกับสัตว์เลี้ยง อาหารที่แนะนำและอื่น ๆ อีกมากมาย',
                              style: TextStyle(fontSize: 14, color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    }

                    // Adjust index for the actual feed posts
                    final FeedPost post = state.feedPosts[index - 1];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 38, 111, 202),  // Container color remains the same
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Updated header text color to white
                              Text(
                                post.header,
                                style: const TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,  // Header text is now white
                                ),
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
                              // Updated description text color to white
                              Text(
                                post.description ?? 'No description available',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,  // Description text is now white
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
