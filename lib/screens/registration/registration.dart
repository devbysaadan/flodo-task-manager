import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaaju/screens/homepage/home_page.dart';
import 'package:kaaju/screens/registration/registration.view_model.dart';
import 'package:get_storage/get_storage.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
final controller = Get.put(RegistrationViewModel());

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('KaaJu',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w800,
            fontSize: 50,
          color: Color(0xffE0AAFF),
        )
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text("Choose your avatar",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  AvatarIcon(),
                  SizedBox(height: 20,),
                  username(),
                  SizedBox(height: 20,),
                  continueBtn(),
                  flower(),

                ]
            ),
          ),
        ),
      ),
    );
  }
}

class AvatarIcon extends StatefulWidget {
  const AvatarIcon({super.key});

  @override
  State<AvatarIcon> createState() => _AvatarIconState();
}

class _AvatarIconState extends State<AvatarIcon> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            setState(() {
              controller.selectedAvatar.value = 'boy';
            });
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: controller.selectedAvatar.value == 'boy' ? Colors.purple : Colors.transparent,
                width: 2,
              )
            ),
            child: CircleAvatar(
              radius: 80,
                child: Image(
                  image: AssetImage('assets/images/boy.png'),
                ),
            ),
          ),
        ),
        SizedBox(width: 10,),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: controller.selectedAvatar.value == 'girl' ? Colors.purple : Colors.transparent,
              width: 2,
            )
          ),
          child: GestureDetector(
            onTap: (){
              setState(() {
                controller.selectedAvatar.value = 'girl';
              });
            },
            child: CircleAvatar(
              radius: 80,
                child: Image(
                  image: AssetImage('assets/images/girl.png'),
                ),
            ),

          ),
        ),
      ],
    );
  }
}
Widget username(){
  return TextFormField(
    controller: controller.usernameController,
    decoration: InputDecoration(
      hintText: "Enter a Username",
      hintStyle: TextStyle(

      )
    ),
  );
}

Widget continueBtn(){
  return ElevatedButton(
      onPressed: (){
        final box = GetStorage();
        box.write('isRegistered', true);
        box.write('userName', controller.usernameController.text);

        Get.offAll(() => const HomePage());      },

    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.purple.shade300,
      elevation: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),

      side: BorderSide(
        color: Colors.purple.shade300,
        style: BorderStyle.solid,
        width: 2
      ),
    ),
    child: Text('Continue',
    style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins'
    ),
  ),
  );
}
Widget flower(){
  return Image(image : AssetImage('assets/images/flower.png')
  );

}




