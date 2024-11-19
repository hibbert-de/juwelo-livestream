import 'package:flutter/material.dart';
import 'package:juwelo_livestream_test/slider/CustomSliderWithTicks.dart';

class PageCustomSlider extends StatefulWidget {
  const PageCustomSlider({super.key});

  @override
  State<PageCustomSlider> createState() => _PageCustomSliderState();
}

class _PageCustomSliderState extends State<PageCustomSlider> {
  @override
  Widget build(BuildContext context) {
    return  SeekBarWithChapters();
  }
}
