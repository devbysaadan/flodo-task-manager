import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/theme_controller.dart';

class ProfileBottomSheet extends StatefulWidget {
  const ProfileBottomSheet({super.key});

  @override
  State<ProfileBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<ProfileBottomSheet> {
  final box = GetStorage();
  final themeController = Get.find<ThemeController>();
  
  late RxString userName;
  late String avatar;
  RxBool isEditing = false.obs;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    userName = (box.read('userName') ?? 'User').toString().obs;
    avatar = box.read('avatar') ?? 'boy';
    nameController = TextEditingController(text: userName.value);
  }

  bool get isDark => themeController.isDarkMode.value;
  Color get bgColor => isDark ? const Color(0xff1E1E1E) : Colors.white;
  Color get textColor => isDark ? Colors.white : const Color(0xff2A0A4A);
  Color get inputBgColor => isDark ? const Color(0xff2A2A2A) : const Color(0xffF8F9FA);

  void saveName() {
    if (nameController.text.trim().isNotEmpty) {
      userName.value = nameController.text.trim();
      box.write('userName', userName.value);
    }
    isEditing.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[700] : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/$avatar.png'),
            backgroundColor: Colors.transparent,
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 16),
          
          // Name with Edit Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isEditing.value)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          style: TextStyle(fontFamily: 'Poppins', color: textColor, fontSize: 18),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: inputBgColor,
                            hintText: "Enter Name",
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                          onSubmitted: (_) => saveName(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: Color(0xff7b2cbf), size: 30),
                        onPressed: saveName,
                      )
                    ],
                  ),
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userName.value,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.edit_rounded, color: isDark ? Colors.white54 : Colors.grey[600], size: 20),
                      onPressed: () {
                        nameController.text = userName.value;
                        isEditing.value = true;
                      },
                    )
                  ],
                ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          Container(
            decoration: BoxDecoration(
              color: inputBgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            ),
            child: ListTile(
              leading: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: const Color(0xffE0AAFF),
              ),
              title: Text(
                "Night Mode",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              trailing: Switch(
                value: isDark,
                activeColor: const Color(0xffc77dff),
                onChanged: (val) {
                  themeController.switchTheme();
                },
              ),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
        ],
      ),
    ));
  }
}
