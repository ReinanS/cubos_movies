import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: deviceSize.width * 0.25,
        height: deviceSize.height * 0.066,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.3,
              blurRadius: 3,
              offset: Offset(0, 0.5), // changes position of shadow
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF7b7e7e),
              size: 13.54,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Voltar',
              style: TextStyle(color: Color(0xFF7b7e7e), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
