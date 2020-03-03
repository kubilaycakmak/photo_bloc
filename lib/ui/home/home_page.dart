import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_bloc/data/model/hits.dart';
import 'package:photo_bloc/ui/global/photo/bloc/photo_bloc.dart';
import 'package:photo_bloc/ui/pages/category_page.dart';
import 'package:photo_bloc/ui/pages/fav_page.dart';
import 'package:photo_view/photo_view.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import '../../main.dart';
import '../global/photo/bloc/photo_bloc.dart';

final Shader linearGradient = LinearGradient(
      colors: <Color>[Colors.teal[900], Colors.teal[200]],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 700.0));
String typeOfPhoto = 'latest';
double dotIndex = 0.0;
bool pageDynamic = true;
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  
  List<Hits> latest;
  List<Hits> popular;
  List<Hits> upcoming;
  @override
  Widget build(BuildContext context) {
    print(typeOfPhoto);
    return Stack(
      children: <Widget>[
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            pageDynamic == true ? Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Text(
                typeOfPhoto,
                style: GoogleFonts.kaushanScript(
                    fontSize: 50,
                    foreground: Paint()..shader = linearGradient),
              ),
            ) : Container(),
            pageDynamic == true ? Padding(
              padding: const EdgeInsets.only(right: 15),
              child: DotsIndicator(
                dotsCount: 4,
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
            ) : Align(
              alignment: Alignment.topCenter,
              child: DotsIndicator(
                dotsCount: 4,
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
        Padding(
          padding: pageDynamic == true ? const EdgeInsets.only(top: 80) : const EdgeInsets.only(top: 20),
          child: buildPageView(),
        )
      ],
    );
  }
  @override
  void initState() { 
    super.initState();
  }
  PageView buildPageView() {
    return PageView(
    scrollDirection: Axis.horizontal,
    onPageChanged: (value) {
      setState(() {
        if (value == 0) {
          selectedIndex = 0;
          typeOfPhoto = 'latest';
          dotIndex = 0.0;
          pageDynamic = true;
        } else if (value == 1) {
          selectedIndex = 0;
          typeOfPhoto = 'popular';
          dotIndex = 1.0;
          pageDynamic = true;
        }
        else if (value == 2) {
          selectedIndex = 1;
          typeOfPhoto = '';
          dotIndex = 2.0;
          pageDynamic = false;
        }
        else if (value == 3) {
          selectedIndex = 2;
          typeOfPhoto = '';
          dotIndex = 3.0;
          pageDynamic = false;
        }
        print('$typeOfPhoto == $value');
      });
    },
    children: <Widget>[
      buildBlocBuilder(),
      buildBlocBuilder(),
      CategoryPage(),
      FavoritePage()
    ],
  );
  }

  BlocBuilder<PhotoBloc, PhotoState> buildBlocBuilder() {
    BlocProvider.of<PhotoBloc>(context).add(FetchHits(typeOfPhoto));
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
          return StaggeredGridView.countBuilder(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: false,
                staggeredTileBuilder: (index) =>
                    StaggeredTile.count(2, index.isEven ? 2 : 3),
                crossAxisCount: 4,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                itemCount: state.hits.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredGrid(
                      duration: const Duration(milliseconds: 175),
                      position: index,
                      columnCount: 3,
                      child: SlideAnimation(
                          verticalOffset: 100.0,
                          duration: Duration(milliseconds: 200),
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
          );
        }
        return Center(
            child: SpinKitWave(
          color: Colors.teal,
          type: SpinKitWaveType.center,
          size: 50.0,
        ));
      },
    );
  }
}
