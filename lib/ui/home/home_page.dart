import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_bloc/ui/global/photo/bloc/photo_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import '../global/photo/bloc/photo_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String typeOfPhoto = 'latest';
  double dotIndex = 0.0;

  @override
  Widget build(BuildContext context) {
    print(typeOfPhoto);
    return PageView(
      scrollDirection: Axis.horizontal,
      onPageChanged: (value) {
        setState(() {
          if (value == 0) {
            typeOfPhoto = 'latest';
            dotIndex = 0.0;
          } else if (value == 1) {
            typeOfPhoto = 'popular';
            dotIndex = 1.0;
          } else {
            typeOfPhoto = 'upcoming';
            dotIndex = 2.0;
          }
          print('$typeOfPhoto == $value');
        });
      },
      children: <Widget>[
        buildBlocBuilder('Latest'),
        buildBlocBuilder('Popular'),
        buildBlocBuilder('Upcoming')
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      title,
                      style: GoogleFonts.kaushanScript(
                          fontSize: 50,
                          foreground: Paint()..shader = linearGradient),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DotsIndicator(
                      dotsCount: 3,
                      position: dotIndex,
                      decorator: DotsDecorator(
                        activeColor: Colors.tealAccent,
                        color: Colors.teal,
                        size: const Size.square(5.0),
                        activeSize: const Size(18.0, 9.0),
                        activeShape: RoundedRectangleBorder(
                            side: BorderSide(
                                style: BorderStyle.solid, color: Colors.black),
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                    ),
                  ),
                ],
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
                          verticalOffset: 500.0,
                          duration: Duration(milliseconds: 1000),
                          child: Container(
                            child: InkWell(
                              onTap: () {
                                slideDialog.showSlideDialog(
                                  context: context,
                                  child: PhotoView(
                                    filterQuality: FilterQuality.high,
                                    basePosition: Alignment.center,
                                    initialScale:
                                        PhotoViewComputedScale.contained * 1.4,
                                    maxScale:
                                        PhotoViewComputedScale.contained * 2,
                                    minScale:
                                        PhotoViewComputedScale.contained * 1,
                                    tightMode: false,
                                    imageProvider: NetworkImage(
                                        state.hits[index].largeUrl,
                                        scale: 0.1),
                                  ),
                                );
                              },
                              child: FadeInAnimation(
                                child: Image.network(
                                  '${state.hits[index].webUrl}',
                                  alignment: Alignment.center,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )));
                },
              ),
            ],
          );
        }

        return Center(
            child: SpinKitSquareCircle(
          color: Colors.black,
          size: 50.0,
        ));
      },
    );
  }
}
