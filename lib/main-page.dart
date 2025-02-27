import 'package:agriteck_user/application-pages/welcome_page.dart';
import 'package:agriteck_user/common-functions/helper-functions.dart';
import 'package:agriteck_user/commonly-used-widget/bottom-icons.dart';
import 'package:agriteck_user/commonly-used-widget/custom_app_bar.dart';
import 'package:agriteck_user/commonly-used-widget/dailog-box.dart';
import 'package:agriteck_user/commonly-used-widget/detect-disease.dart';
import 'package:agriteck_user/commonly-used-widget/floating-buttton.dart';
import 'package:agriteck_user/community-page/commuinity-page.dart';
import 'package:agriteck_user/community-page/contribution_page.dart';
import 'package:agriteck_user/diseases-page/diseases-page.dart';
import 'package:agriteck_user/home-page/home-screen.dart';
import 'package:agriteck_user/pojo-classes/tips-data.dart';
import 'package:agriteck_user/services/sharedPrefs.dart';
import 'package:async_loader/async_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agriteck_user/styles/app-colors.dart';
import 'package:flutter/services.dart';


enum BottomButtons {
  
  Home,
  Community,
  Diseases,
}

class MainPage extends StatefulWidget {
  final BottomButtons initPage;
  MainPage({Key key, this.initPage}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BottomButtons selectedPage;
  List<Widget> bottomNavButtons = [];
  String userName, userPhone, userImage, userType, pageTitle = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  final GlobalKey<AsyncLoaderState> _asyncLoaderState2 =
      new GlobalKey<AsyncLoaderState>();

  @override
  void initState() {
    selectedPage = widget.initPage;
    super.initState();
  }

  getUserInfo() async {

  }

  setPageTitle() {
    String title = '';
    if (selectedPage == BottomButtons.Diseases) title = 'Diseases';
    if (selectedPage == BottomButtons.Community) title = 'Community';
    return title;
  }


  Widget setFloatBott(selectedPage) {
    return  selectedPage == BottomButtons.Community 
            ? FloatingButton(
                label: 'Ask Community',
                icon: Icons.edit,
                onPressHandler: () {},
              )
            : selectedPage == BottomButtons.Diseases
                ? FloatingButton(
                    label: 'Detect Disease',
                    icon: Icons.photo_camera,
                    onPressHandler: () {
                      detectDisease(context);
                    },
                  )
                : null;
  }

  Future<bool> _onBackPressed() async {
    return showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: 'Quit !',
                descriptions:
                    'Are you Sure you want to quit this application ?',
                btn1Text: 'No',
                btn2Text: 'Yes',
                img: 'assets/images/warning.png',
                btn1Press: () {
                  Navigator.pop(context);
                },
                btn2Press: () {
                  setState(() {
                    SystemNavigator.pop();
                  });
                },
              );
            }) ??
        false;
  }
//======================================================================

  @override
  Widget build(BuildContext context) {
    // Asyn Load the Drawer Info
    var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await getUserInfo(),
      renderLoad: () => Center(child: new CircularProgressIndicator()),
      renderError: ([error]) =>
          new Text('Sorry, there was an error loading your Information'),
      renderSuccess: ({data}) => Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [primaryDark, primary, primaryLight],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    tileMode: TileMode.clamp)),
            accountName: Text(
              userName != null ? userName : "UserName",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            accountEmail: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userPhone != null ? userPhone : "Telephone"),
                  SizedBox(height: 3),
                  Text(userType != null
                      ? 'Signed In As: ${userType.characters.getRange(0, userType.length - 1)}'
                      : '')
                ],
              ),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white,
              backgroundImage: userImage != null
                  ? NetworkImage(userImage)
                  : AssetImage('assets/images/person.png'),
            ),
          ),
        ),
      ),
    );

    //  Asyn Load the Bottom Nav Button
    var _asyncLoadBottomNav = new AsyncLoader(
      key: _asyncLoaderState2,
      initState: () async => await getUserInfo(),
      renderLoad: () => Center(child: new CircularProgressIndicator()),
      renderError: ([error]) =>
          new Text('Sorry, there was an error loading your Information'),
      renderSuccess: ({data}) => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BottomIcons(
            iconColor: Colors.grey,
            text: 'Home',
            bottomIcons: selectedPage == BottomButtons.Home ? true : false,
            icons: 'assets/icons/home.png',
            textColor: primary,
            onPressed: () {
              setState(() {
                selectedPage = BottomButtons.Home;
              });
            },
            activeColor: primary,
            activeIconColor: primary,
          ),
          BottomIcons(
            iconColor: Colors.grey,
            text: 'Community',
            bottomIcons: selectedPage == BottomButtons.Community ? true : false,
            icons: 'assets/icons/community.png',
            textColor: primary,
            onPressed: () {
              setState(() {
                selectedPage = BottomButtons.Community;
              });
            },
            activeColor: primary,
            activeIconColor: primary,
          ),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: Container(
            color: Colors.white,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                _asyncLoader,
                ListTile(
                  leading: Image(
                    width: 24,
                    image: AssetImage('assets/icons/cultivate.png'),
                    color: Colors.black54,
                  ),
                  trailing: Icon(Icons.chevron_right),
                  title: Text(
                    'Diseases',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Send to Diseases Page
                    sendToPage(context, DiseasesScreen());
                  },
                ),
                ListTile(
                  leading: Image(
                    width: 24,
                    image: AssetImage('assets/icons/community.png'),
                    color: Colors.black54,
                  ),
                  trailing: Icon(Icons.chevron_right),
                  title: Text(
                    'Comm. Contributions',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Send to Communtiy Contribution Page
                    sendToPage(context, ContributionScreen());
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.chevron_right),
                  title: Text(
                    'Profile',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  leading: Icon(Icons.chevron_right),
                  title: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    // Update the state of the app.
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    sendToPage(context, WelcomeScreen());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.arrow_forward),
                  title: Text(
                    'Exit',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: CustomAppBar(
          leadingIcon: Icons.menu,
          title: setPageTitle(),
          onIconPress: () {
            setState(() {
              _scaffoldKey.currentState.openDrawer();
            });
          },
        ),
        floatingActionButton: setFloatBott(selectedPage),
        body: selectedPage == BottomButtons.Home
            ? HomeScreen(
                tips: Tips.testTips()[0],
              )
            : selectedPage == BottomButtons.Community
                ? CommunityScreen()
                : selectedPage == BottomButtons.Diseases
                    ? DiseasesScreen()
                    : Container(),
        bottomNavigationBar: Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: _asyncLoadBottomNav),
      ),
    );
  }
}
