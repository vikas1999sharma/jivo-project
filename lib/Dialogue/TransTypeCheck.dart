import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:myproject/SapModel/TransType.dart';

class TranstypeCheck extends StatefulWidget {
  TranstypeCheck(
      {this.transTypeList, this.onItemsSelected, this.onDialogueCancelled});

  final List<TransType> transTypeList;
  final ValueChanged<List<int>> onItemsSelected;
  final List<int> selectedTransTypeIndexes = new List<int>();
  final List<int> deSelectedTransTypeIndexes = new List<int>();
  final ValueChanged<Map<String, List<int>>> onDialogueCancelled;

  @override
  TranstypeCheckState createState() => TranstypeCheckState();
}

class TranstypeCheckState extends State<TranstypeCheck> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ListView in Voucher'),
      content: Container(
          height: 300.0,
          width: 300.0,
          child: ListView.builder(
            itemCount: widget.transTypeList.length,
            itemBuilder: (BuildContext context, int index) {
              TransType transType = widget.transTypeList[index];
              return CheckboxListTile(
                title: Text(transType.transName),
                value: transType.isSelected,
                onChanged: (bool value) {
                  setState(() {
                    transType.isSelected = value;
                  });

                  if (value) {
                    widget.selectedTransTypeIndexes.add(index);
                    widget.deSelectedTransTypeIndexes.remove(index);
                  } else {
                    widget.selectedTransTypeIndexes.remove(index);
                    widget.deSelectedTransTypeIndexes.add(index);
                  }
                },
              );
            },
          )),
      actions: <Widget>[
        new FlatButton(
          child: new Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
            Map<String, List<int>> selectDeSelectMap = new HashMap();

            selectDeSelectMap.putIfAbsent(
                "SELECTED_INDEXES", () => widget.selectedTransTypeIndexes);
            selectDeSelectMap.putIfAbsent(
                "UNSELECTED_INDEXES", () => widget.deSelectedTransTypeIndexes);
            widget.onDialogueCancelled(selectDeSelectMap);
          },
        ),
        FlatButton(
            child: Text('Ok'),
            onPressed: () {
              widget.onItemsSelected(widget.selectedTransTypeIndexes);
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
