import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as html_parser;
import 'package:movieflix/pages/detailsscreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  _homescreenstate createState() => _homescreenstate();
}

class _homescreenstate extends State<Homescreen> {
  List movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  String _cleanHtml(String htmlContent) {
    final document = html_parser.parse(htmlContent);
    return document.body?.text ?? 'No description available';
  }

  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: Image.asset(
          "assets/app_title/b456015b7c55a8d7addfca493fc01420.png",
          width: 180,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              size: 40,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.popAndPushNamed(context, 'search');
            },
          ),
        ],
      ),
      body: movies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHorizontalList('Popular Movies', movies),

                  _buildHorizontalList('Top Rated Movies', movies),

                  _buildHorizontalList('Trending Movies', movies),
                ],
              ),
            ),
    );
  }

  Widget _buildHorizontalList(String category, List movies) {
    double devicewidth = MediaQuery.sizeOf(context).width;
    double deviceheight = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              category,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: deviceheight * 0.025,
                  color: Colors.white),
            ),
          ),
          SizedBox(height: 18),
          Container(
            height: deviceheight * 0.25, 
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index]['show'];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsScreen(movie: movie)),
                    );
                  },
                  child: Card(
                    color: Colors.black,
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            movie['image']?['medium'] ?? 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAANgAAACUCAMAAADGZBfIAAAACVBMVEX///+Ntff///3xWUAfAAAAr0lEQVR4nO3PAREAMAgAIbf+oc2B9zRg3p+bimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmKaYppimmuxhYHyAG92v6XOgAAAABJRU5ErkJggg==',
                            height: deviceheight * 0.2,
                            width: devicewidth * 0.3,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            movie['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: deviceheight * 0.018),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
