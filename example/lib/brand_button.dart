import 'package:flutter/material.dart';

class BrandButton extends StatelessWidget {
  const BrandButton({
    Key? key,
    required this.brandName,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  final String brandName;
  final Function() onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(
        brandName,
        style: Theme.of(context).textTheme.button!.copyWith(color: color),
      ),
    );
  }
}
