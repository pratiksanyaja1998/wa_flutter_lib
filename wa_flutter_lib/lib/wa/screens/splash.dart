
import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key,}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String displayText = "";

  @override
  void initState() {

    getBusinessAppConfig();
    
    super.initState();
  }

  Future<void> getBusinessAppConfig()async{
    await Future.delayed(const Duration(seconds: 0));
    BusinessAppConfigModel? businessAppConfigModel = SharedPreference.getBusinessConfig();
    if(businessAppConfigModel != null){
      displayText = "";
      await BusinessServices().getAppConfig();
    }else{
      displayText = "We are setting up your app...";
      setState(() {});
      await BusinessServices().getAppConfig();
      displayText = "";
    }
    if(!mounted) return;
    if(isLoginRequired){
      if(SharedPreference.isLogin()){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => homeScreen));
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => homeScreen));
    }
  }

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage("assets/images/logo.png"), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset("assets/images/logo.png", width: 80, height: 80,),
                ),
              ),
              const SizedBox(height: 10,),
              if(displayText.isNotEmpty)
                Text(
                  displayText,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
