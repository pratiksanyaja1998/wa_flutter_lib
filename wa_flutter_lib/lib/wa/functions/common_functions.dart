
import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

class CommonFunctions{

  void showAlertDialog({required String alertMessage, required BuildContext context}){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              alertMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15,),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          actions: [
            Row(
              children: [
                Expanded(
                  child: Widgets().textButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      text: getTranslated(context, ["common", "ok"])
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void showConfirmationDialog({
    required String confirmationMessage,
    required String confirmButtonText,
    required String cancelButtonText,
    required BuildContext context,
    required void Function()? onConfirm,
  }){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              confirmationMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15,),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          actions: [
            Row(
              children: [
                Expanded(
                  child: Widgets().textButton(
                    onPressed: onConfirm,
                    text: confirmButtonText,
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: Widgets().textButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    text: cancelButtonText,
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void showSuccessModal({required BuildContext context, bool success = true}){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Container(
          constraints: const BoxConstraints(
              maxHeight: 190
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(success ? Icons.done_all_rounded : Icons.close_rounded, color: success ? Colors.green : Colors.red, size: 40,),
              Text(
                success ? "Payment Successful" : "Payment failed",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: success ? Colors.green : Colors.red,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15,),
              Row(
                children: [
                  Expanded(
                    child: Widgets().textButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        text: getTranslated(context, ["common", "ok"])
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  void showError({required var data, required BuildContext context}){
    if(data.containsKey("detail")){
      printMessage("---- ${data["detail"]}");
      showAlertDialog(
        alertMessage: data["detail"], context: context,
      );
    }else if(data.containsKey("non_field_errors")){
      showAlertDialog(
        alertMessage: data["non_field_errors"][0], context: context,
      );
    }else if(data.containsKey("message")){
      showAlertDialog(
        alertMessage: data["message"], context: context,
      );
    }else{
      showAlertDialog(
        alertMessage: "$data", context: context,
      );
    }
  }

  void showBottomSheet({required Widget child, required BuildContext context}){
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      builder: (context){
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 10, right: 10, top: 10),
          child: Stack(
            children: [
              Center(
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              Center(
                child: child,
              ),
            ],
          ),
        );
      },
    );
  }

}