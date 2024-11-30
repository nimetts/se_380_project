import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Tracker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text("Today\'s Highlight",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              height: 150,
              color: Colors.purple[100],
              child: Center(
                child: Text("highlight of the Day"),
              ),
            ),
            SizedBox(height: 16),
            Text("For you",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 0.6,),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Expanded(child: Image.asset(
                        "assets/book_placeholder.png", fit: BoxFit.cover,),
                      ),
                      Text("Book title"),
                    ],
                  ),
                );
              },
            ),
            ),
          ],
        ),
      ),
    );
  }
}