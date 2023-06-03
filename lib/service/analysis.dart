import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';

Color colorResult(double data,String name,String target){
  switch ( name ) {
    case "temperature": {
      switch( target ){
        case "海水" :{

        }
        case "渔业" :{

        }
        case "地表水" :{

        }
      }
    }
    case "PH": {
      switch( target ){
        case "海水" :{
          if(data>7.8&&data<8.5){
            return Colors.green;
          }
          else if((data>=6.8&&data<=7.8)&&(data>=8.5&&data<=8.8)){
            return Colors.yellow;
          }
          else{
            return Colors.red;
          }
        }
        case "渔业" :{

        }
        case "地表水" :{

        }
      }
    }
    case "electrical": {
      switch( target ){
        case "海水" :{

        }
        case "渔业" :{

        }
        case "地表水" :{

        }
      }
    }
    case "O2": {
      switch( target ){
        case "海水" :{

        }
        case "渔业" :{

        }
        case "地表水" :{

        }
      }
    }
    case "dirty": {
      switch( target ){
        case "海水" :{

        }
        case "渔业" :{

        }
        case "地表水" :{

        }
      }
    }
    case "green": {
      switch( target ){
        case "海水" :{

        }
        case "渔业" :{

        }
        case "地表水" :{

        }
      }
    }
    case "NHN": {
      switch( target ){
        case "海水" :{

        }
        case "渔业" :{

        }
        case "地表水" :{

        }
      }
    }
    case "oil": {
      switch( target ){
        case "海水" :{

        }
        case "渔业" :{

        }
        case "地表水" :{

        }
      }
    }
  }
  return Colors.black;
}