import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Welcome to Flutter',
        home: HomePage()
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Field Photo',
            style: TextStyle(
              fontSize:22.0,
              color: Colors.black,
            )
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Form(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[400],
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(5)
                      ),
                      color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              hintText: 'Username',
                            ),
                        ),
                      ),
                      Container(
                        color: Colors.grey,
                        height: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.blue,
                            hintText: 'Password',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                child: FlatButton(
                    onPressed: (){},
                    color: Colors.green[700],
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                      ),
                    )
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar : BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
            height: 50.0
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.photo_camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
