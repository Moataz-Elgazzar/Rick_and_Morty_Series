import 'package:flutter/widgets.dart';

class heroImage extends StatelessWidget {
  final String image;

  const heroImage(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      width: double.infinity,
      child: Image.network(image, fit: BoxFit.cover),
    );
  }
}