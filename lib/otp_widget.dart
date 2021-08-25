library otp_widget;

import 'package:flutter/material.dart';

class OTPWidget extends StatefulWidget{
  final String? title;
  final TextStyle? titleStyle;
  final TextEditingController? controller;
  final Color? borderColor;
  final Color? focusedColor;
  final Color? cursorColor;
  final String? hint;
  final TextStyle? hintStyle;
  final int otpSize;
  
  OTPWidget({
    this.title, 
    this.titleStyle, 
    this.controller,
    this.otpSize=6,
    this.hint,
    this.hintStyle,
    this.borderColor,
    this.focusedColor,
    this.cursorColor
  });

  @override
  State<OTPWidget> createState() => _OTPWidgetState();

}

class _OTPWidgetState extends State<OTPWidget>{
  late final List<FocusNode> focusNodes;
  late final List<TextEditingController> controllers;
  late final TextEditingController mainController;
  late Function() listener;

  @override
  void initState() {
    mainController = widget.controller??TextEditingController();
    focusNodes = List.generate(widget.otpSize, (index) => FocusNode());
    controllers = List.generate(widget.otpSize, (index) => TextEditingController());
    listener = () {
      for (int i = 0; i < widget.otpSize; i++) {
        try {
          controllers[i].text =
              mainController.text.characters.elementAt(i);
        } catch (e) {
          print("No value in $i otp field");
        }
      }
    };
    listener();
    mainController.addListener(listener);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final List<TextEditingController> controllers = [];//useOtpControllersWithTextEditingController(controller);

    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.title!=null?Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child:Text(widget.title!, style: widget.titleStyle)
          ):SizedBox(),
          Row(
              mainAxisSize: MainAxisSize.min,
              children:
              List.generate(widget.otpSize, (index) =>
                  Flexible(child: TextField(
                    textAlign: TextAlign.center,
                    showCursor: false,
                    enableInteractiveSelection: false,
                    keyboardType: TextInputType.number,
                    controller: controllers[index],
                    onChanged: (n){
                      if(index==widget.otpSize-1)
                      {
                        controllers[index].text = n.characters.last;
                        focusNodes[index].unfocus();
                      }else{
                        controllers[index].text = n.characters.last;
                        focusNodes[index].unfocus();
                        focusNodes[index+1].requestFocus();
                        Future.delayed(Duration(milliseconds: 100),()
                        {
                          controllers[index].selection = TextSelection.collapsed(
                              offset: controllers[index].text.length);
                        });
                      }
                    },
                    onTap: (){
                      focusNodes[index].requestFocus();
                      controllers[index].selection = TextSelection.collapsed(offset: controllers[index].text.length);
                    },
                    focusNode: focusNodes[index],
                    cursorColor: widget.cursorColor??widget.focusedColor,
                    decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle: widget.hintStyle,
                        alignLabelWithHint: true,
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.focusedColor??Colors.black, width: 2), borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.borderColor??Colors.grey), borderRadius: BorderRadius.circular(10))
                    ),
                  ), flex: 2,),
              )
          )
        ]);
  }

  @override
  void dispose() {
    mainController.removeListener(listener);
    super.dispose();
  }
}