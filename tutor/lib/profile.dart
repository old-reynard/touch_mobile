import 'package:flutter/material.dart';
import 'dart:ui';
import 'data/constants.dart';
import 'models/models.dart';
import 'services/profile_service.dart';

var picLink =
    "https://media.licdn.com/dms/image/C5603AQE2q8V20iJlZg/profile-displayphoto-shrink_200_200/0?e=1553126400&v=beta&t=HiHzyVpYWlxVT03B1kLcrMh6rxwVcpKPW3SuqJFiEZA";
var profilePic = NetworkImage(picLink);

class ProfilePage extends StatefulWidget {
  ProfilePage({this.user});

  final User user;

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService profileService = ProfileService();
  User newUser;

  @override
  void initState() {
    super.initState();
    profileService.getUser().then((user) {
      setState(() {
        newUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _profileAppBar(),
        SliverPrototypeExtentList(
          prototypeItem: _specialty(),
          delegate: SliverChildListDelegate([
            _specialty(),
            _biography(),
          ]),
        ),
      ],
    ));
  }

  Widget _profileAppBar() {
    return SliverAppBar(
        pinned: true,
        expandedHeight: 350.0,
        title: Text('Name'),
        floating: true,
        snap: false,
        flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.network(
                  picLink,
                  fit: BoxFit.cover,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: <Widget>[
                        Stack(
                            alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              Container(
                                width: 200.0,
                                height: 200.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: iconsColor),
                              ),
                              Container(
                                width: 190.0,
                                height: 190.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.fill, image: profilePic)),
                              ),
                            ]),
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Container(
                              width: 45.0,
                              height: 45.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: iconsColor),
                            ),
                            CircleAvatar(
                              backgroundColor: accentColor,
                              child: InkWell(
                                child: Icon(
                                  Icons.edit,
                                  color: iconsColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                ),
              ],
            ),
            title: Text('sliver')));
  }

  Widget _specialty() {
    return Wrap(
      spacing: 8.0,
      alignment: WrapAlignment.center,
      children: newUser.specialties
          .map((Specialty spec) => Chip(
                avatar: CircleAvatar(
                  child: Text(spec.name.substring(0, 1)),
                ),
                label: Text(spec.name.length < 20
                    ? spec.name
                    : spec.name.substring(0, 20) + '...'),
              ))
          .toList(),
    );
  }

  Widget _biography() {
    return Text(newUser.biography);
  }
}
