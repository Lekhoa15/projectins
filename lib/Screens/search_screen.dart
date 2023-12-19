import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:projectins/Screens/profile_screen.dart';
import 'package:projectins/utils/colors.dart';
import 'package:projectins/utils/global_variables.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  final userdata = FirebaseFirestore.instance.collection('users');
  final postdata = FirebaseFirestore.instance.collection('posts');

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(labelText: 'Search for a User'),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUsers = true;
              print('value: $_');
            });
          },
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: userdata.where(
                'username',
                isGreaterThanOrEqualTo: searchController.text,
                isLessThan: searchController.text + 'z',
                whereNotIn: [searchController.text.toUpperCase()],
              ).get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final listuser = snapshot.data!.docs;
                  // print('listuser: ${listuser.map((e) => e.data())}');
                  return ListView.builder(
                      itemCount: listuser.length,
                      itemBuilder: (context, index) {
                        final user = snapshot.data!.docs[index].data();
                        // print('user: $user');
                       return InkWell(
                          
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                               builder: (context) =>
                                  ProfileScreen(uid: (snapshot.data! as dynamic).docs[index]['uid'] ,
                                  ),
                            ),
                          ),
                          child: ListTile(
                            leading: user['photoUrl'] != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user['photoUrl']),
                                    radius: 16,
                                  )
                                : null,
                            title: Text(
                              user['username'],
                            ),
                          ),
                        );
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : FutureBuilder(
              future: postdata.get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) => Image.network(
                        (snapshot.data! as dynamic).docs[index]['postUrl']),
                    staggeredTileBuilder: (index) =>MediaQuery.of(context).size.width > webScreenSize ?StaggeredTile.count(
                      (index % 7 == 0) ? 1 : 1,
                      (index % 7 == 0) ? 1 : 1,
                    ) : StaggeredTile.count(
                      (index % 7 == 0) ? 2 : 1,
                      (index % 7 == 0) ? 2 : 1,
                    ),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  );
                }
              },
            ),
    );
  }
}
