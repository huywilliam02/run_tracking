import 'package:flutter/material.dart';
import 'package:tracker_run/app/resources/data_constant.dart';
import '../enum/enum.dart';
import '../models/drink_record.dart';
import '../utils/datetime_utils.dart';

class RecordListTile extends StatelessWidget {
  const RecordListTile({
    Key? key,
    required this.record,
    this.onDeleteActionTap,
  }) : super(key: key);

  final DrinkRecord record;
  final void Function()? onDeleteActionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20,
          padding: const EdgeInsets.only(left: 21),
          child: VerticalDivider(
            color: Palette.foregroundColor.withOpacity(0.5),
            thickness: 1.2,
          ),
        ),
        ListTile(
          leading: Image.asset(
            AssetIconPaths.mapCapcityWithIconPath[record.capacity]!['fill']
                as String,
            width: 28,
            height: 28,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateTimeUtils.timeTo12HourFormatString(record.time),
                style: const TextStyle(
                  color: Palette.foregroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Text(
                '${record.capacity} ml',
                style: TextStyle(
                  color: Palette.foregroundColor.withOpacity(0.4),
                  fontSize: 14,
                ),
              )
            ],
          ),
          trailing:IconButton(onPressed: onDeleteActionTap, icon: Icon(Icons.close_sharp,color: Colors.white,))
          // PopupMenuButton<RecordListTileAction>(
          //   child: const Icon(
          //     Icons.more_vert_rounded,
          //     color: Palette.foregroundColor,
          //   ),
          //   itemBuilder: (context) => [
          //     PopupMenuItem<RecordListTileAction>(
          //       onTap: ,
          //       value: RecordListTileAction.delete,
          //       child: const Text('Xóa'),
          //     ),
          //   ],
          // ),
        ),
      ],
    );
  }
}
