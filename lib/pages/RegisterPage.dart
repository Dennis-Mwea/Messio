import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messio/blocs/authentication/AuthenticationBloc.dart';
import 'package:messio/blocs/authentication/AuthenticationState.dart';
import 'package:messio/blocs/authentication/Bloc.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Decorations.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Styles.dart';
import 'package:messio/config/Transitions.dart';
import 'package:messio/pages/ContactListPage.dart';
import 'package:messio/widgets/CircleIndicator.dart';
import 'package:messio/widgets/NumberPicker.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int currentPage = 0;
  File profileImageFile;
  ImageProvider profileImage;
  int age = 18;
  final TextEditingController usernameController = TextEditingController();
  var isKeyboardOpen =
      false; // Keeps track of the keyboard, when its shown and when its hidden
  PageController pageController =
      PageController(); // Used to naviage back and fourth the page
  //Fields related to animation of the gradient
  Alignment begin = Alignment.center;
  Alignment end = Alignment.bottomRight;

  //Fields related to animating the layout and pushing widgets up when the focus is on the username field
  AnimationController usernameFieldAnimationController;
  Animation profilePicHeightAnimation, usernameAnimation, ageAnimation;
  FocusNode usernameFocusNode = FocusNode();
  AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              buildHome(),
              BlocBuilder(
                builder: (context, state) {
                  if (state is AuthInProgress ||
                      state is ProfileUpdateInProgress) {
                    return buildCircularProgressBarWidget();
                  }

                  return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    usernameFieldAnimationController.dispose();
    usernameFocusNode.dispose();

    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;

    if (value > 0) {
      if (isKeyboardOpen) {
        onKeyboardChanged(false);
      }
      isKeyboardOpen = false;
    } else {
      isKeyboardOpen = true;
      onKeyboardChanged(true);
    }
  }

  Container buildHome() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: [
            Palette.gradientStartColor,
            Palette.gradientEndColor,
          ],
        ),
      ),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (int page) => updatePageState(page),
            children: <Widget>[
              buildPageOne(),
              buildPageTwo(),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < 2; i++) CircleIndicator(i == currentPage),
              ],
            ),
          ),
          buildUpdateProfileButtonWidget(),
        ],
      ),
    );
  }

  AnimatedOpacity buildUpdateProfileButtonWidget() {
    return AnimatedOpacity(
      opacity: currentPage == 1 ? 1.0 : 0.0,
      //shows only on page 1
      duration: Duration(milliseconds: 500),
      child: Container(
        margin: EdgeInsets.only(right: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () => authenticationBloc.dispatch(
                  SaveProfile(profileImageFile, age, usernameController.text)),
              elevation: 0,
              backgroundColor: Palette.primaryColor,
              child: Icon(
                Icons.done,
                color: Palette.accentColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Column buildPageOne() {
    return Column(
      children: <Widget>[
        buildHeaderSectionWidget(),
        buildGoogleButtonWidget(),
      ],
    );
  }

  Column buildHeaderSectionWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 250.0),
          child: Image.asset(
            Assets.app_icon_fg,
            height: 100.0,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Text(
            'Messio Messenger',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ],
    );
  }

  Container buildGoogleButtonWidget() {
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: FlatButton.icon(
        onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
            .dispatch(ClickedGoogleLogin()),
        color: Colors.transparent,
        icon: Image.asset(
          Assets.google_button,
          height: 25,
        ),
        label: Text(
          'Sign In with Google',
          style: TextStyle(
            color: Palette.primaryTextColorLight,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  InkWell buildPageTwo() {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            profileImage = Image.asset(Assets.user).image;
            if (state is PrefillData) {
              age = state.user.age != null ? state.user.age : 18;
              profileImage = Image.network(state.user.photoUrl).image;
            } else if (state is ReceivedProfilePicture) {
              profileImageFile = state.file;
              profileImage = Image.file(profileImageFile).image;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: profilePicHeightAnimation.value,
                ),
                buildProfilePictureWidget(),
                SizedBox(
                  height: ageAnimation.value,
                ),
                Text(
                  'How old are you?',
                  style: Styles.questionLight,
                ),
                buildAgePickerWidget(),
                SizedBox(
                  height: usernameAnimation.value,
                ),
                Text(
                  'Choose a username',
                  style: Styles.questionLight,
                ),
                buildUsernameWidget(),
              ],
            );
          },
        ),
      ),
    );
  }

  Row buildAgePickerWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        NumberPicker.horizontal(
            initialValue: age,
            minValue: 15,
            maxValue: 100,
            highlightSelectedValue: true,
            onChanged: (num value) {
              setState(() {
                age = value;
              });
            }),
        Text('Years', style: Styles.textLight)
      ],
    );
  }

  Container buildUsernameWidget() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: 120,
      child: TextField(
          textAlign: TextAlign.center,
          style: Styles.subHeadingLight,
          focusNode: usernameFocusNode,
          controller: usernameController,
          decoration: Decorations.getInputDecoration(
            hint: '@username',
            isPrimary: false,
          )),
    );
  }

  GestureDetector buildProfilePictureWidget() {
    return GestureDetector(
      onTap: pickImage,
      child: CircleAvatar(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.camera,
              color: Colors.white,
              size: 15,
            ),
            Text(
              'Set Profile Picture',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            )
          ],
        ),
        backgroundImage: profileImage,
        radius: 60,
      ),
    );
  }

  Container buildCircularProgressBarWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: [
            Palette.gradientStartColor,
            Palette.gradientEndColor,
          ],
        ),
      ),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              buildHeaderSectionWidget(),
              Container(
                margin: EdgeInsets.only(top: 100.0),
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Palette.primaryColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void initApp() {
    usernameFieldAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    profilePicHeightAnimation =
        Tween(begin: 100.0, end: 0.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });
    usernameAnimation =
        Tween(begin: 50.0, end: 10.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });
    ageAnimation =
        Tween(begin: 80.0, end: 10.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });
    usernameFocusNode.addListener(() {
      if (usernameFocusNode.hasFocus) {
        usernameFieldAnimationController.forward();
      } else {
        usernameFieldAnimationController.reverse();
      }
    });
    pageController.addListener(() {
      setState(() {
        begin = Alignment(pageController.page, pageController.page);
        end = Alignment(1 - pageController.page, 1 - pageController.page);
      });
    });
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    authenticationBloc.state.listen((state) {
      if (state is Authenticated) {
        updatePageState(1);
      }
    });
  }

  void updatePageState(index) {
    if (currentPage == index) return;

    if (index == 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

      setState(() {
        currentPage = index;
      });
    }
  }

  Future<bool> onWillPop() async {
    if (currentPage == 1) {
      // Go to page 1 if currently on second page
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

      return false;
    } else {
      return true;
    }
  }

  Future pickImage() async {
    profileImageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    authenticationBloc.dispatch(PickedProfilePicture(profileImageFile));
  }

  void onKeyboardChanged(bool isVisible) {
    if (!isVisible) {
      FocusScope.of(context).requestFocus(FocusNode());

      usernameFieldAnimationController.reverse();
    }
  }

  void navigateToHome() {
    Navigator.push(
      context,
      SlideLeftRoute(page: ContactListPage()),
    );
  }
}
