import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:sbbwu_session18_omdb_api/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:sbbwu_session18_omdb_api/widgets/movie_item.dart';


class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {

  Color myFavColor = Color.fromARGB(255, 140, 150, 120);
  Color secondColor = Color(0xffff0000);

  TextEditingController movieNameController = TextEditingController();
  late StreamController streamController;
  late Stream stream;
  Movie? movie;


  @override
  initState() {

    streamController = StreamController();
    stream = streamController.stream;

    streamController.add('empty');
    super.initState();
  }


  searchMovie( {required String movieName}) async {

    streamController.add('loading');

    String url = 'https://www.omdbapi.com/?t=$movieName&plot=full&apikey=94e188aa';

    http.Response response = await  http.get(Uri.parse(url));

    if( response.statusCode == 200 ){

      var jsonResponse = jsonDecode(response.body);

      movie = Movie.fromJson(jsonResponse);

      if( movie!.response == 'True'){
        streamController.add(movie);
      }else{
        streamController.add('Not Found');
      }
    }else{
      streamController.add('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myFavColor,
        title: const Text('Movie Searcher'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: movieNameController,
                decoration: const InputDecoration(
                  hintText: 'Movie Name',
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.cancel),
                      label: const Text('Clear')),
                  const Gap(10),
                  OutlinedButton.icon(
                      onPressed: () {

                        String movieName = movieNameController.text.trim();

                        if( movieName.isEmpty){
                          // flutter toast show
                        }else{
                          // search for movie
                          searchMovie(movieName: movieName);
                        }
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Search')),
                ],
              ),

              StreamBuilder(stream: stream, builder: (context, snapshot){
                if( snapshot.data == 'empty'){
                  return const Center(child: Text('Write a Movie name'),);
                }

                if( snapshot.data == 'loading'){
                  return const Center(child: SpinKitWave(color: Colors.deepOrange,));

                }

                if( snapshot.data == 'Not Found'){
                  return const Center(child: Text('Movie Not Found'),);
                }

                Movie movie = snapshot.data as Movie;

                return Card(child: Column(
                  children: [
                    const Gap(16),
                    CircleAvatar(
                      radius: 120,
                        backgroundImage: NetworkImage(movie.poster!)),
                    const Gap(16),
                    MovieItem(heading: 'Country', value: movie.country!),
                    const Gap(16),
                    MovieItem(heading: 'Language', value: movie.language!),
                    const Gap(16),
                    MovieItem(heading: 'Actors', value: movie.actors!),
                    const Gap(16),
                    MovieItem(heading: 'Plot', value: movie.plot!),

                  ],
                ));



              })
            ],
          ),
        ),
      ),
    );
  }
}
