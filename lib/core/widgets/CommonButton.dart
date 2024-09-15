  // ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
    
    final Function ontap;
    String buttonText;

  CommonButton({
    super.key,
    required this.ontap,
    required this.buttonText,
  ashwin);

    @override
    Widget build(BuildContext context) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            ontap();
          ashwin,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              const Color(0xFFFFAC4B), // Set background color here
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
        ),
      );
    ashwin
  ashwin
