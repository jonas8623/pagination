import 'dart:convert';

import 'package:exemplo_pagination/components/component_post.dart';
import 'package:exemplo_pagination/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostOverviewPage extends StatefulWidget {
  const PostOverviewPage({Key? key}) : super(key: key);

  @override
  State<PostOverviewPage> createState() => _PostOverviewPageState();
}

class _PostOverviewPageState extends State<PostOverviewPage> {

  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _numberOfPostsPerRequest = 10;
  late List<PostModel> _posts;
  final int _nextPageTrigger = 3;

  @override
  void initState() {
    super.initState();
    _pageNumber = 0;
    _posts = [];
    _isLastPage = false;
    _loading = true;
    _error = false;
    fetchPosts();
  }

  Future<void> fetchPosts() async {

    try {
      final response = await http.get(
          Uri.parse(
              "https://jsonplaceholder.typicode.com/posts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest"));
      List responseList = json.decode(response.body);
      List<PostModel> postList = responseList.map((data) => PostModel(title: data['title'], body: data['body'])).toList();

      setState(() {
        _isLastPage = postList.length < _numberOfPostsPerRequest;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        _posts.addAll(postList);
      });
    } catch(error) {
        print('error -> $_error');
        setState(() {
          _loading = false;
          _error = true;
        });
    }
  }

  Widget errorDialog() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Um erro ocorreu ao pegar os posts'),
          const SizedBox(height: 8.0,),
          ElevatedButton(onPressed: _onPressed(), child: const Text('Tentar Novamente'))
        ],
      ),
    );
  }

  Widget postsView() {
    if (_posts.isEmpty) {
      if (_loading) {
        return const Center(
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
        ),);
      } else if (_error) {
          return Center(child: errorDialog(),);
      }
    }
    return ListView.builder(
        physics: ScrollPhysics(),
        itemCount: _posts.length + (_isLastPage ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == _posts.length - _nextPageTrigger) {
              fetchPosts();
          }
          if (index == _posts.length) {
             if (_error) {
               return Center(child: errorDialog(),);
             } else {
               return const Center(
                 child: Padding(
                     padding: EdgeInsets.all(8.0),
                     child: CircularProgressIndicator(),
                 ),);
             }
          }
          final PostModel post = _posts[index];
          return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ComponentPost(title: post.title, body: post.body),
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
        elevation: 4.0,
      ),
      body: postsView(),
    );
  }


  _onPressed() {
    setState(() {
      _loading = true;
      _error = false;
      fetchPosts();
    });
  }
}


