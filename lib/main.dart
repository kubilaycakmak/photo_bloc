import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
int selectedIndex = 0;
void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,

      systemNavigationBarDividerColor: Colors.transparent,
      ));
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
  
  List children = [HomePage(), CategoryPage(), FavoritePage()];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      sized: true,
      value: SystemUiOverlayStyle,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: Scaffold(
          backgroundColor: Color(0xFFECECEC),
          body: BlocProvider(
            create: (context) => PhotoBloc(repository: widget.repository),
            child: children[selectedIndex],
          ),
          extendBody: true,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color(0xFFECECEC),
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.teal[900],
            iconSize: 20,
            elevation: 0,
            selectedFontSize: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            onTap: (int val) {
              setState(() {
                print('$dotIndex ---------------');
                if(val == 1){
                  dotIndex = 0;
                  typeOfPhoto = 'latest';
                  pageDynamic = true;
                }
                selectedIndex = val;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: selectedIndex == 0 ? Icon(Icons.home) : Icon(CupertinoIcons.home),
                  title: Text('Latest')
                  ),
              BottomNavigationBarItem(
                  icon: selectedIndex == 1
                      ? Icon(CupertinoIcons.collections_solid)
                      : Icon(CupertinoIcons.collections),
                  title: Text('Category')),
              BottomNavigationBarItem(
                  icon:
                      selectedIndex == 2 ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                  title: Text('Favorite')),
            ],
          ),
        ),
      ),
    );
  }
}
