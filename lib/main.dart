import 'package:dots_indicator/dots_indicator.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_bloc/data/hits_api_client.dart';
import 'package:photo_bloc/data/hits_repository.dart';
import 'package:http/http.dart' as http;
import 'package:photo_bloc/ui/global/photo/bloc/photo_bloc.dart';
import 'package:photo_bloc/ui/pages/category_page.dart';
import 'package:photo_bloc/ui/pages/fav_page.dart';
import 'ui/home/home_page.dart';

class SimpleBlocDelegate extends BlocDelegate {
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final HitsRepository repository =
      HitsRepository(hitsApiClient: HitsApiClient(httpClient: http.Client()));
  runApp(MyApp(repository: repository));
}

class MyApp extends StatefulWidget {
  final HitsRepository repository;
  const MyApp({Key key, this.repository})
      : assert(repository != null),
        super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;
  List children = [HomePage(), CategoryPage(), FavoritePage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        backgroundColor: Color(0xFFECECEC),
        body: BlocProvider(
          create: (context) => PhotoBloc(repository: widget.repository),
          child: children[selectedIndex],
        ),
        extendBody: true,
        bottomNavigationBar: FloatingNavbar(
          backgroundColor: Color(0xB63D3D3D),
          selectedItemColor: Colors.white,
          selectedBackgroundColor: Colors.white10,
          unselectedItemColor: Colors.white70,
          unselectedBackgroundColor: Colors.transparent,
          fontSize: 10,
          iconSize: 28,
          currentIndex: selectedIndex,
          onTap: (int val) {
            setState(() {
              selectedIndex = val;
            });
          },
          items: [
            FloatingNavbarItem(
                icon: selectedIndex == 0 ? Icons.home : CupertinoIcons.home,
                title: 'Latest'),
            FloatingNavbarItem(
                icon: selectedIndex == 1
                    ? CupertinoIcons.collections_solid
                    : CupertinoIcons.collections,
                title: 'Category'),
            FloatingNavbarItem(
                icon:
                    selectedIndex == 2 ? Icons.favorite : Icons.favorite_border,
                title: 'Favorite'),
          ],
        ),
      ),
    );
  }
}
