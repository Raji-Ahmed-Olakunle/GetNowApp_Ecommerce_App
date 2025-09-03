import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModeNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async{
   return await getMode();
  }
  setMode(bool islightmode)async{
    final prefAccess = await SharedPreferences.getInstance();
    try{
      prefAccess.setBool('isLightMode',islightmode);
      state=AsyncValue.data(prefAccess.getBool('isLightMode')!);
    }
    catch(e){

    }
  }

  Future<bool> getMode()async{
    print("hello");
    final prefAccess = await SharedPreferences.getInstance();
    try{
      if(prefAccess.containsKey('isLightMode')){
        bool mode=prefAccess.getBool('isLightMode')!;
        return mode;
      }
      else{
        prefAccess.setBool('isLightMode', true);
        return true;
      }


    }
    catch(e){
print(e);
    }
    return true;
  }


}
final ModeProvider=AsyncNotifierProvider<ModeNotifier,bool>((){
  return ModeNotifier();
});