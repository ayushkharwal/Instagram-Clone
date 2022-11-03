import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/pages/login_page.dart';
import 'package:instagram_clone/resourses/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Text Ediing Controllers
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _bioTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
  Uint8List? _image;

  // dispose function
  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _bioTextController.dispose();
    _usernameTextController.dispose();
    super.dispose();
  }

  // Function to pick profile picture
  void selectProfilePicture() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  // SignUp Function
  void signUpUser() async {
    String res = await AuthMethods().signUpUser(
      email: _emailTextController.text,
      password: _passwordTextController.text,
      username: _usernameTextController.text,
      bio: _bioTextController.text,
      file: _image!,
    );
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }

  // To navigate to Login Page
  navigateToLoginPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Flexible widget is used to give spacing between svg image and the top
                  //Flexible(flex: 2, child: Container()),

                  // svg image
                  SvgPicture.asset(
                    'assets/instagram.svg',
                    color: primaryColor,
                    height: 64,
                  ),

                  const SizedBox(height: 64),

                  // Add Profile Picture
                  Stack(
                    children: [
                      // Profile Picture
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://i.pinimg.com/474x/65/25/a0/6525a08f1df98a2e3a545fe2ace4be47.jpg'),
                            ),

                      // Add Profile Picture button
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectProfilePicture,
                          icon: Icon(
                            Icons.add_a_photo_rounded,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 64),

                  // Email TextField
                  TextFieldInput(
                    textEditingController: _emailTextController,
                    textInputType: TextInputType.emailAddress,
                    hintText: 'Email',
                  ),

                  const SizedBox(height: 20),

                  // Username TextField
                  TextFieldInput(
                    textEditingController: _usernameTextController,
                    textInputType: TextInputType.text,
                    hintText: 'Username',
                  ),

                  const SizedBox(height: 20),

                  // Password TextField
                  TextFieldInput(
                    textEditingController: _passwordTextController,
                    textInputType: TextInputType.text,
                    hintText: 'Password',
                    isPassword: true,
                  ),

                  const SizedBox(height: 20),

                  // Bio TextField
                  TextFieldInput(
                    textEditingController: _bioTextController,
                    textInputType: TextInputType.text,
                    hintText: 'Bio',
                  ),

                  const SizedBox(height: 20),

                  // SignUp Button
                  InkWell(
                    onTap: signUpUser,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ),

                  const SizedBox(height: 10),
                  //Flexible(flex: 2, child: Container()),

                  // Navigate to LoginPage
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Text('Already have an account? '),
                      ),
                      GestureDetector(
                        onTap: navigateToLoginPage,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            'Login Here',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
