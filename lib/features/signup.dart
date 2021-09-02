import 'package:flutter/material.dart';

import 'home.dart';
import 'login-demo.dart';

class SignupWidget extends StatefulWidget {
  @override
  static const routeName = 'SignupWidget';
  _SignupWidgetState createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  Item selectedUser;
  List<Item> users = <Item>[
    const Item('Android',Icon(Icons.android,color:  const Color(0xFF167F67),)),
    const Item('Flutter',Icon(Icons.flag,color:  const Color(0xFF167F67),)),
    const Item('ReactNative',Icon(Icons.format_indent_decrease,color:  const Color(0xFF167F67),)),
    const Item('iOS',Icon(Icons.mobile_screen_share,color:  const Color(0xFF167F67),)),
  ];
  @override
  Widget  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
//      appBar: AppBar(
//        title: Text("Signup Page"),
//      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0,bottom: 20.0),
              child: Center(
                child: Text('Sign Up',style:TextStyle(fontSize: 25.0))),

            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Company Name',
                    hintText: 'Enter valid company name'),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Company Phone',
                    hintText: 'Enter valid company Phone'),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Company Address',
                    hintText: 'Enter valid company Address'),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
              child: Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[350], width: 2),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: DropdownButton<Item>(
                    underline: SizedBox(),
                    iconSize: 40.0,
                    hint:  Text("Choose Industry"),
                    value: selectedUser,
                    isExpanded: true,
                    onChanged: (Item Value) {
                      setState(() {
                        selectedUser = Value;
                      });
                    },
                    items: users.map((Item user) {
                      return  DropdownMenuItem<Item>(
                        value: user,
                        child: Row(
                          children: <Widget>[
                            user.icon,
                            SizedBox(width: 100,),
                            Text(
                              user.name,
                              style:  TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    }).toList(),) ,
              )
                  ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child:Row(children: [
                Expanded(
                  flex: 1,
                  child:   TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contact Name',
                      hintText: 'Enter valid company Address'),
                ),),

                SizedBox(width:20.0),
                Expanded(
                  flex: 1,
                  child:  TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contact Phone',
                      hintText: 'Enter valid company Address'),
                ),
                ),
              ],)
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contact Email',
                    hintText: 'Enter valid company Phone'),
              ),
            ),
            Padding(
          padding: EdgeInsets.symmetric(horizontal: 15,),
            child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 50,
              width: 250,

              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomeWidget()));
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}
class Item {
  const Item(this.name,this.icon);
  final String name;
  final Icon icon;
}