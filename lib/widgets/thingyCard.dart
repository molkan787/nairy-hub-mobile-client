import 'package:flutter/material.dart';
import 'package:nairy_hub/entities/thingy.dart';

class ThingyCard extends StatelessWidget {
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;

  final Thingy data;
  final bool isArchived;

  final bool isHighLighted = false;

  const ThingyCard({
    super.key,
    required this.data,
    this.isArchived = false,
    this.onLongPress,
    this.onTap,
  });

  Color get bgColor {
    if (data.isCompleted) {
      return Colors.green.shade100;
    } else if (isHighLighted) {
      return Colors.blue.shade200;
    } else {
      return Colors.blue.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isArchived ? 0.3 : 1.0,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: bgColor,
        margin: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
        child: InkWell(
            onLongPress: onLongPress,
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            splashColor: Colors.blue.shade200,
            highlightColor: Colors.green.shade100,
            child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          data.summary,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: Text(data.content),
                        )
                      ],
                    ),
                  ),
                ),
                if (data.isCompleted)
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 48,
                        color: Colors.green.shade200,
                      ),
                    ),
                  )
              ],
            )),
      ),
    );
  }
}
