import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          cursorColor: Colors.indigo,
          style: Theme.of(context).textTheme.headline3,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search documents...",
              hintStyle: Theme.of(context).textTheme.headline3,
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Theme.of(context).iconTheme.color,),
                onPressed: () {
                  //TODO: Clear search textfield function
                },
              )),
        ),
      ),
    );
  }
}
