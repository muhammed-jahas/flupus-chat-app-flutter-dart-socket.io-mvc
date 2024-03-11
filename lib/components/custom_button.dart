import 'package:flupus/resources/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback buttonFuntion;
  CustomButton({
    required this.buttonText,
    required this.buttonFuntion,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: ElevatedButton(
        style: ButtonStyle(
            padding:
                MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 14)),
            shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
            elevation: MaterialStatePropertyAll(0),
            backgroundColor: MaterialStatePropertyAll(AppColors.primaryColor)),
        onPressed: buttonFuntion,
        child: Text(
          buttonText,
          style: TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
      ),
    );
  }
}
