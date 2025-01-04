import 'package:flutter/material.dart';

extension screenSize on BuildContext{
  get screenWith => MediaQuery.of(this).size.width;
  get screenHight => MediaQuery.of(this).size.height;
}