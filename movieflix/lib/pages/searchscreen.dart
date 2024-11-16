import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movieflix/pages/detailsscreen.dart';

class Searchscreen extends StatefulWidget {
  @override
  _SearchscreenState createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Future<void> fetchMovies(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://api.tvmaze.com/search/shows?q=$query');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _searchResults = json.decode(response.body);
        });
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    } catch (error) {
      setState(() {
        _searchResults = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.red,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[850],
          hintText: "Search for movies...",
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (value) => fetchMovies(value),
      ),
    );
  }

  Widget _buildResultsList() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          "No results found",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final show = _searchResults[index]['show'];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(movie: show),
                ),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: show['image'] != null
                      ? Image.network(
                          show['image']['medium'],
                          width: 90,
                          height: 135,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 90,
                          height: 135,
                          color: Colors.grey,
                          child: Icon(Icons.movie, color: Colors.white),
                        ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(
                        show['name'] ?? "Unknown",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        show['genres']?.join(', ') ?? "No genres",
                        style: TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Search",
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.popAndPushNamed(context, 'home');
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          _buildSearchBar(),
          Expanded(child: _buildResultsList()),
        ],
      ),
    );
  }
}
