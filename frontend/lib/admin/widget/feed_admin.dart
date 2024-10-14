import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/appbar/navbar.dart';
import 'package:frontend/admin/appbar/slidebar.dart';
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
      appBar: const Navbar(), 
      drawer: const Sidebar(), 
      body: BlocProvider(
        create: (context) => FeedBloc(feedRepository: FeedRepository(apiUrl: 'https://pets-care.onrender.com'))..add(FetchFeedData()),
        child: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            if (state is FeedLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FeedLoaded) {
              return Container(
                color: Colors.white,  
                child: ListView.builder(
                  itemCount: state.feedPosts.length + 1, 
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'lib/images/logo.png',  
                              height: 170,            
                              width: 170,            
                              fit: BoxFit.contain,      
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

                    final FeedPost post = state.feedPosts[index - 1];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 38, 111, 202),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.header,
                                  style: const TextStyle(
                                    fontSize: 18, 
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,  
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
                                  Image.network(
                                    post.imageUrl!,
                                    fit: BoxFit.cover,
                                    height: 200, 
                                    width: double.infinity, 
                                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                      return const Text(
                                        'Image failed to load.',
                                        style: TextStyle(color: Colors.white),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                Text(
                                  post.description ?? 'No description available',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
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
