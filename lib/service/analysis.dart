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
            return Colors.red.shade900;
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
          if(data>=3&&data<4){
            return Colors.red.shade50;
          }
          else if(data>=4&&data<5){
            return Colors.yellowAccent.shade100;
          }
          else if(data>=5&&data<6){
            return Colors.yellow;
          }
          else if(data>6){
            return Colors.green;
          }
          else{
            return Colors.red.shade900;
          }
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
  return Colors.blue;
}