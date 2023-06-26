import 'package:flutter/material.dart';
import 'db_sqlite.dart';
import 'main.dart';
import 'film.dart';
import 'theaters.dart';
import 'berita.dart';

void main() => runApp(const tabBar());

class tabBar extends StatelessWidget {
  const tabBar({super.key});

  static const String _title = 'Tab Bar';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.shutter_speed_rounded),
        title: Text('Movie Time'),
        backgroundColor: Colors.teal[900],
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.movie),
              text: "Film"
            ),
            Tab(
              icon: Icon(Icons.theaters),
              text: "Theaters",
            ),
            Tab(
              icon: Icon(Icons.article),
              text: "Berita",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Center(
            child: Film(),
          ),
          Center(
            child: Theaters(),
          ),
          Center(
            child: Berita(),
          ),
        ],
      ),
    );
  }
}
