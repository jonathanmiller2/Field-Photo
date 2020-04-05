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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[400],
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(5)
                    )
                ),

                child: Column(
                  children: <Widget>[
                    TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          hintText: 'Username',
                        )
                    ),
                    Divider(
                      color: Colors.grey[400],
                      thickness: 1,
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.blue,
                        hintText: 'Password',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(25),
            child: FlatButton(
                onPressed: (){},
                color: Colors.green[700],
                child: Text(
                  'Sign In',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),
                )
            ),
          )
        ],
      ),
      bottomNavigationBar : BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0,),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.photo_camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
