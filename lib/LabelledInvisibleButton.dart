import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabelledInvisibleButton extends StatefulWidget {
	final String label;
	final Function onPress;
	final Color defaultColor;
	final Color pressedColor;
	final bool centered;
	final FontWeight fontWeight;
	final double fontSize;
	
	const LabelledInvisibleButton({this.label, this.onPress, this.defaultColor = Colors.blue, this.pressedColor = Colors.white, this.centered = true, this.fontSize = 18, this.fontWeight = FontWeight.bold});
	
	_LabelledInvisibleButtonState createState() => _LabelledInvisibleButtonState();
}

class _LabelledInvisibleButtonState extends State<LabelledInvisibleButton> {
	bool pressed = false;
	@override
	Widget build(BuildContext context) {
		
		Text textBody = Text(
			widget.label,
			style: TextStyle(
					color: pressed ? widget.pressedColor : widget.defaultColor,
					fontSize: widget.fontSize,
					fontWeight: widget.fontWeight
			),
		);
		
		if(widget.centered)
		{
			return InkWell(
				child: Center(child: textBody),
				onTap: () {
					setState(() {
						pressed = false; //onTap occurs when the finger is lifted, thus pressed should be set to false
						widget.onPress();
					});
				},
				onTapDown: (a) {
					setState(() {
						pressed = true;
					});
				},
			);
		}
		else
		{
			return InkWell(
					child: textBody,
					onTap: () {
						setState(() {
							pressed = false; //onTap occurs when the finger is lifted, thus pressed should be set to false
							widget.onPress();
						});
					},
					onTapDown: (_) {
						setState(() {
							pressed = true;
						});
					},
					onTapCancel: () {
						setState(() {
							pressed = false;
						});
					},
					onFocusChange: (_) {
						setState(() {
							pressed = false;
						});
					},
					onHighlightChanged: (_) {
						setState(() {
							pressed = false;
						});
					},
					onLongPress: () {
						setState(() {
							pressed = false;
						});
					},
					onHover: (_) {
						setState(() {
							pressed = false;
						});
					}
			);
		}
	}
}
