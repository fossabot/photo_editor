import 'package:flutter/material.dart';

class BottomBarContainer extends StatefulWidget {
  final Color colors;
  final Function ontap;
  final Function onlongpress;
  final String title;
  final IconData icons;
  final bool active;

  const BottomBarContainer(
      {Key key,
      this.ontap,
      this.title,
      this.icons,
      this.colors,
      this.active,
      this.onlongpress})
      : super(key: key);

  @override
  _BottomBarContainerState createState() => _BottomBarContainerState();
}

class _BottomBarContainerState extends State<BottomBarContainer> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 80,
      color: widget.colors,
      child: Material(
        color: Colors.black87,
        child: InkWell(
          onTap: widget.ontap,
          onLongPress: widget.onlongpress,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Icon(
                widget.icons,
                color: Colors.white,
              ),
              new SizedBox(
                height: 4,
              ),
              new Text(
                widget.title,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
