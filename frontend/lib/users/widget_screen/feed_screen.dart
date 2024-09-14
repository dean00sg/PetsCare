import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/feed_bloc.dart';
import 'package:frontend/users/event/feed_event.dart';
import 'package:frontend/users/state/feed_state.dart';
import '../styles/feed_style.dart';

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
        create: (_) => FeedBloc()..add(FetchFeedData()),
        child: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            if (state is FeedLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FeedLoaded) {
              return ListView.builder(
                itemCount: state.articles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: containerDecoration,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.articles[index],
                              style: headerTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              'อ่านบทความสุขภาพสัตว์เลี้ยงของคุณได้ที่นี่!',
                              style: contentTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            // แสดงรูปภาพจำลอง
                            Image.asset(
                              'lib/images/cat_1.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'รู้หรือไม่? ว่านอกจากจะลดน้ำหนักด้วยการออกกำลังกายแล้ว ก็ยังมีวิธีง่ายๆ ช่วยให้ลดน้ำหนักได้ดี อีกหนึ่งวิธีคือ การควบคุมปริมาณ Kcal ต่อวันของอาหารที่เรากินเข้าไปนั่นเอง ซึ่งการกินแบบนับแคลอรี่นั้นจะช่วยให้ร่างกายได้รับสารอาหารเพียงพอต่อปริมาณที่ร่างกายต้องการในแต่ละวัน โดยวิธีที่เราจะมาแนะนำกันในวันนี้คือ วิธีคำนวณปริมาณแคลอรี่ ต่อวัน ด้วยสูตร Basal Metabolic Rate (BMR) หรือการหาค่าพลังงานที่ร่างกายต้องการอย่างน้อยในแต่ละวัน เพื่อให้เรากินอาหารได้อย่างเหมาะสมมากขึ้นค่ะ',
                              style: subContentTextStyle,
                              textAlign: TextAlign.center,
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
