import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../model/post.dart';
import '../widgets/post_item.dart';

class ScrollControllerDemo extends StatefulWidget {

  @override
  _ScrollControllerDemoState createState() => _ScrollControllerDemoState();
}
class _ScrollControllerDemoState extends State<ScrollControllerDemo> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  late int _numberOfPostsPerRequest;
  late List<Post> _posts;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _pageNumber = 0;
    _posts = [];
    _isLastPage = false;
    _loading = true;
    _error = false;
    _numberOfPostsPerRequest = 10;
    _scrollController = ScrollController();
    fetchData();
  }


  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> fetchData() async {
    print("invoked");
    try {
      final response = await get(Uri.parse(
          "https://jsonplaceholder.typicode.com/posts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest"));
      List responseList = json.decode(response.body);
      List<Post> postList = responseList.map((data) => Post(data['title'], data['body'])).toList();

      setState(() {
        _isLastPage = postList.length < _numberOfPostsPerRequest;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        _posts.addAll(postList);
      });
    } catch (e) {
      print("error --> $e");
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }


  Widget errorDialog({required double size}){
    return SizedBox(
      height: 180,
      width: 200,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('An error occurred when fetching the posts.',
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w500,
                color: Colors.black
            ),
          ),
          const SizedBox(height: 10,),
          FlatButton(
              onPressed:  ()  {
                setState(() {
                  _loading = true;
                  _error = false;
                  fetchData();
                });
              },
              child: const Text("Retry", style: TextStyle(fontSize: 20, color: Colors.purpleAccent),)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      // nextPageTrigger will have a value equivalent to 80% of the list size.
      var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > nextPageTrigger) {
        _loading = true;
        fetchData();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Blog App"), centerTitle: true,),
      body: buildPostsView(),
    );
  }


  Widget buildPostsView() {
    if (_posts.isEmpty) {
      if (_loading) {
        return const Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ));
      } else if (_error) {
        return Center(
            child: errorDialog(size: 20)
        );
      }
    }
    return ListView.builder(
        controller: _scrollController,
        itemCount: _posts.length + (_isLastPage ? 0 : 1),
        itemBuilder: (context, index) {

          if (index == _posts.length) {
            if (_error) {
              return Center(
                  child: errorDialog(size: 15)
              );
            }
            else {
              return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ));
            }
          }

            final Post post = _posts[index];
            return Padding(
                padding: const EdgeInsets.all(15.0),
                child: PostItem(post.title, post.body)
            );
        }
        );
  }


}

