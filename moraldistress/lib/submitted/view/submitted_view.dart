import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:moraldistress/assets/constants.dart' as Constants;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moraldistress/assets/colors.dart' as uvacolors;
import 'package:moraldistress/submitted/submitted.dart';
import 'package:moralpainapi/moralpainapi.dart' as api;
import 'package:url_launcher/url_launcher.dart';

class SubmittedView extends StatefulWidget {
  @override
  SubmittedViewState createState() => SubmittedViewState();
}

class SubmittedViewState extends State<SubmittedView> {
  final resourcesController = DraggableScrollableController();
  final resourcesSheetMinChildSize = 0.1;
  final resourcesSheetInitialChildSize = 0.1;
  final resourcesSheetMaxChildSize = .75;
  var _resourcesShowing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.APPBAR_TEXT),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(flex: 2, child: thankYouHeader(context)),
                Flexible(
                    flex: 1,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "If you need immediate relief please page PIC1712 to notify the MDC",
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyText1,
                        ))),
                Flexible(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Swipe up for suggested resiliency resources",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                  flex: 1,
                ),
                Flexible(flex: 4, child: SizedBox()),
              ]),
          NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                print(notification.extent);
                // NB (nphair): Be sure to round to handle precision of doubles.
                var rounded =
                    double.parse((notification.extent).toStringAsFixed(3));
                if (rounded == notification.maxExtent) {
                  showResources();
                } else if (rounded == notification.minExtent) {
                  hideResources();
                }
                return true;
              },
              child: DraggableScrollableSheet(
                  minChildSize: resourcesSheetMinChildSize,
                  maxChildSize: resourcesSheetMaxChildSize,
                  initialChildSize: resourcesSheetInitialChildSize,
                  snap: true,
                  controller: resourcesController,
                  builder: (context, scrollableController) {
                    return Padding(
                        padding: EdgeInsets.all(10),
                        child: BlocBuilder<ResourcesBloc, ResourcesState>(
                            builder: (context, state) {
                          if (state is ResourcesLoaded) {
                            var cards = state.resources.resources!;
                            return Container(
                                child: ListView.builder(
                                    itemCount: cards.length + 1,
                                    controller: scrollableController,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == 0) {
                                        return Material(
                                            child: resiliencyHeader());
                                      }

                                      // NB: Have to minus 1 to account for header.
                                      var r = cards[index - 1];
                                      return Material(
                                          child: ListTile(
                                              leading: buildIcon(r),
                                              title: Text(r.title!),
                                              onTap: () {
                                                context
                                                    .read<ResourcesBloc>()
                                                    .add(ResourceVisitedEvent(
                                                        r.resourceId!));
                                                _launchURL(r.url!);
                                              }));
                                    }));
                          } else {
                            return Container();
                          }
                        }));
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<ResourcesBloc>().add(VisitedResourcesSubmitEvent());
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Icon(Icons.home_rounded)),
    );
  }

  void showResources() => setState(() {
        _resourcesShowing = true;
      });

  void hideResources() => setState(() {
        _resourcesShowing = false;
      });

  ListTile resiliencyHeader() {
    if (_resourcesShowing) {
      return ListTile(title: Icon(Icons.arrow_drop_down_outlined));
    }
    return ListTile(title: Icon(Icons.arrow_drop_up_outlined));
  }

  Widget thankYouHeader(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        child: new Container(
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

                colors: <Color>[
                  uvacolors.UVABlueTints,
                  uvacolors.UVABlueTints.shade50
                ],
                tileMode:
                    TileMode.clamp, // repeats the gradient over the canvas
              ),
              boxShadow: [
                BoxShadow(
                    color: uvacolors.UVABlueTints.shade100, spreadRadius: 2),
                BoxShadow(
                    color: uvacolors.UVABlueTints.shade200,
                    spreadRadius: 4,
                    blurRadius: 3),
              ],
              color: uvacolors.UVABlue,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Thank You!",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .apply(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Your MoD score is important to us and has been recorded",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .apply(color: Colors.white),
                    textAlign: TextAlign.center,
                  )
                ])),
      );

  Widget buildIcon(api.ResiliencyResource resiliencyResource) {
    final input = resiliencyResource.icon!;
    final iconData = IconData(
        int.parse(input.codePoint!.replaceFirst('0x', ''), radix: 16),
        fontFamily: input.fontFamily);
    return Icon(iconData, size: 40.0);
  }

  void _launchURL(String url) async => await canLaunch(url)
      ? await launch(url, forceWebView: true, enableJavaScript: true)
      : throw 'Could not launch $url';
}

// TODO (nphair): Replace with a model.
class HelpfulLink {
  final String title;
  final String description;
  final IconData icon;
  final String url;

  const HelpfulLink(this.title, this.description, this.icon, this.url);
}
