import 'package:flutter/material.dart';
import 'package:reading_app/widget/section/default_section.dart';
import 'package:reading_app/widget/section/favorite_section.dart';
import 'package:reading_app/widget/section/my_book_section.dart';

class Section extends StatefulWidget {
  const Section({Key? key, required this.material}) : super(key: key);
  final String? material;

  @override
  State<Section> createState() => _SectionState();
}

///define save category section
const String labelFavoriteCategory = "SAVED";

///define mypaper category section
const String labelPersonalCategory = "MYPAPER";

class _SectionState extends State<Section> {
  @override
  Widget build(BuildContext context) {
    if (widget.material == labelFavoriteCategory) {
      return const FavoriteSection();
    }
    if (widget.material == labelPersonalCategory) {
      return const MyBookSection();
    } else {
      return DefaultSection(material: widget.material);
    }
  }
}
