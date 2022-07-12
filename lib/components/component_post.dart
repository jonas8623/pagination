import 'package:flutter/material.dart';

class ComponentPost extends StatelessWidget {

  final String title;
  final String body;

  const ComponentPost({Key? key, required this.title, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 326,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.blueGrey
      ),
      child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 22
              ),),
              const SizedBox(height: 14,),
              Text(body, style: const TextStyle(
                color: Colors.black87,
                fontSize: 18
              ),)
            ],
          ),
      ),
    );
  }
}
