import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_bloc/ui/global/photo/bloc/photo_bloc.dart';

import '../global/photo/bloc/photo_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String typeOfPhoto = 'latest';

  @override
  Widget build(BuildContext context) {
    print(typeOfPhoto);
    return PageView(
      scrollDirection: Axis.horizontal,
      onPageChanged: (value) {
        setState(() {
          if (value == 0) {
            typeOfPhoto = 'latest';
          } else {
            typeOfPhoto = 'popular';
          }
          print('$typeOfPhoto == $value');
        });
      },
      children: <Widget>[
        buildBlocBuilder('Latest'),
        buildBlocBuilder('Popular')
      ],
    );
  }

  BlocBuilder<PhotoBloc, PhotoState> buildBlocBuilder(String title) {
    BlocProvider.of<PhotoBloc>(context).add(FetchHits(typeOfPhoto));
    final Shader linearGradient = LinearGradient(
        colors: <Color>[Colors.teal[900], Colors.teal[200]],
      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 700.0));
    return BlocBuilder<PhotoBloc, PhotoState>(
    builder: (context, state) {
      if (state is HitsEmpty) {
        print('in bloc builder : $typeOfPhoto');
      }
      if (state is HitsError) {
        return Center(
          child: Text('failed to fetch photos'),
        );
      }
      if (state is HitsLoaded) {
        return ListView(
          shrinkWrap: false,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                title,
                style: GoogleFonts.kaushanScript(
                  fontSize: 50,
                  foreground: Paint()..shader = linearGradient
                ),
              ),
            ),
            StaggeredGridView.countBuilder(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              staggeredTileBuilder: (index) =>
              StaggeredTile.count(2, index.isEven ? 2 : 3), 
              crossAxisCount: 4,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              itemCount: state.hits.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  duration: const Duration(milliseconds: 375),
                  position: index,
                  columnCount: 3,
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: InkWell(
                      onTap: (){
                        print(state.hits[index].id);
                      },
                      child: FadeInAnimation(
                        child: Image.network(
                          '${state.hits[index].webUrl}',
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  )
                );
              },
            ),
          ],
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
  }
}
