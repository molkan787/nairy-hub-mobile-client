import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final IconData icon;
  final bool loading;
  final Color? color;

  const ActionButton(this.icon,
      {super.key, this.loading = false, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: SizedBox(
          width: 26,
          height: 26,
          child: (loading
              ? const CircularProgressIndicator(
                  value: null,
                  color: Colors.black87,
                  strokeWidth: 3,
                )
              : Icon(icon, color: color)),
        ),
      ),
    );
  }
}
