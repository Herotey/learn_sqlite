// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:sqlite_learn/dataBase.dart';
import 'package:sqlite_learn/model.dart';

class ItemCard extends StatefulWidget {
   late Model model;
  late TextEditingController input1;
  late TextEditingController input2;
   late Function onDeletePress;
   late Function onUpdatePress;
 ItemCard( {super.key, required Model model, required TextEditingController input1, required TextEditingController input2, required Null Function() onDeletePress, required Null Function() onUpdatePress} );

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final DbManager dbManager = DbManager();
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
       child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Name :${widget.model.fruitName}',
              style:const TextStyle(fontSize: 15),),
              Text('Quantity : ${widget.model.quantity}',
              style: const TextStyle(fontSize: 10),)
            ],
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed:() =>
                    widget.onUpdatePress,
                  icon:const Icon(Icons.edit),
                  color: Colors.blueAccent,
                  ),
              ),
              const SizedBox(height: 30,),
              CircleAvatar(
                child: IconButton(onPressed: ()=>
                  widget.onDeletePress,
                 icon:const Icon(Icons.delete) ,
                 color: Colors.red,),
              )
            ],
          )
        ]),
      ),
    );
  }
}
class DialogBox{
  Widget dialog({
    required BuildContext context,
    required Function onPressed,
    required TextEditingController textEditingController1,
    required TextEditingController textEditingController2,
    required FocusNode input1FocusNode,
    required FocusNode input2FocusNode
  })
  {
  return AlertDialog(
    title: Text("Enter data"),
    content: Container(
      height: 100,
      child: Column(
        children: [
          TextFormField(
            controller: textEditingController1,
            keyboardType: TextInputType.text,
            autofocus: true,
            decoration: InputDecoration(hintText: "Fruit Name"),
            onFieldSubmitted: (value) {
               input1FocusNode.unfocus();
              FocusScope.of(context).requestFocus(input2FocusNode);
            },
          ),
          TextFormField(
            controller: textEditingController2,
            keyboardType: TextInputType.number,
            focusNode: input2FocusNode,
            decoration: InputDecoration(hintText: "Quantity"),
            onFieldSubmitted: (value) {
               input2FocusNode.nextFocus();
            },
          )
          
        ],
      ),
    ),
    actions: [
      MaterialButton(onPressed: (){
        Navigator.of(context).pop();
      },
      color: Colors.blueGrey,
      child: Text("Cancel"),),
      MaterialButton(
        onPressed:() => onPressed,
      color: Colors.blue,
      child: Text("Submit"),)
    ],
  );
  }
}