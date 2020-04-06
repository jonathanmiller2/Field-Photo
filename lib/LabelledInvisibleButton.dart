import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabelledInvisibleButton extends StatefulWidget {
	final String label;
	final Function onPress;
	
	const LabelledInvisibleButton({this.label, this.onPress});
	
	_LabelledInvisibleButtonState createState() {
		return _LabelledInvisibleButtonState();
	}
}

class _LabelledInvisibleButtonState extends State<LabelledInvisibleButton> {
	bool pressed = false;
	@override
	Widget build(BuildContext context) {
		return InkWell(
			child: Center(
				child: Text(
					widget.label,
					style: TextStyle(
							color: pressed ? Colors.white : Colors.blue[900],
							fontSize: 18,
							fontWeight: FontWeight.bold
					),
				),
			),
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
}
