
import 'package:permission_handler/permission_handler.dart';

// Future<void> requestPermission({required Permission permission }) async{

//   final status =  await permission.status;

//   if (status.isGranted) {
//     debugPrint("Permission is already granted");         
//   } 
//   else if (status.isDenied) {
//     if(await permission.request().isGranted){
//       debugPrint("Permission granted");
//     }
//     else{
//       debugPrint("Permission denied");
//     }    
//   }
//   else{
//     debugPrint("Permission denied");
//   }

// }

Future<bool> requestPermission(Permission permission) async {
  var status = await permission.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    var result = await permission.request();
    return result.isGranted;
  } else {
    return false;
  }
}