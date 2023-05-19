
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LinkPage extends StatelessWidget {

  void _onLinkBtn(){

  }

  const LinkPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('数据连接'),
      ),
      body: Row(
        children: <Widget>[
          Expanded(flex:1,child: Row(),),
          Expanded(
            flex:1,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    Text('连接无人船',style: TextStyle(fontSize: 40,fontFamily: '黑体'),),
                    SizedBox(height: 50,),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "IP地址",
                          border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 30,),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "端口号",
                          border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 30,),
                    TextButton(
                      onPressed: _onLinkBtn,
                      child: Text('连接',style: TextStyle(fontSize: 15,color: Colors.white),),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        minimumSize: Size(300, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(flex:1,child: Row(),),
        ],
      ),
    );
  }
}
