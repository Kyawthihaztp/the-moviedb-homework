import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_movie_home_work/movie.dart';

void main() {
  runApp(
    MaterialApp(
      home: MoviesHome(),
    )
  );
}




class MoviesHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MoviesState();
  }

}
class MoviesState extends State<MoviesHome> {
  
  var url= "https://api.themoviedb.org/3/movie/top_rated?api_key=e7cbed7311b200c64b3d1a077053ae3a";
  MovieHub movieHub;
  
@override
void initState(){
  super.initState();
  fetchData();
}

 fetchData() async{
   var data= await http.get(url);
   var jsonData=jsonDecode(data.body);
   movieHub=MovieHub.fromJson(jsonData);
 }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Movies'),
     ),
     body: movieHub==null
     ?Center(
       child: CircularProgressIndicator(),
     ):GridView.count(crossAxisCount: 2,
     children: 
     movieHub.results.map((result) => Padding(
       padding: EdgeInsets.all(2.0),
       child: InkWell(
         onTap: (){
           Navigator.push(context, 
           MaterialPageRoute(builder: (context)=>
           new MoviesDetail(results:result)
           )
           );
         },
         child: Hero(
           tag: result.posterPath,
           child: Card(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: <Widget>[
                 Container(
                   height: 120.0,
                   child: Image.network("https://image.tmdb.org/t/p/w200${result.posterPath}",
                   fit: BoxFit.fill),
                   
                 ),
                 Text(
                   result.title
                 )
               ],
             ),
           ),
         ),
       ),
     )
     ).toList(),
     ),
   );
  }

  
  }

  class MoviesDetail extends StatelessWidget{
    final Results results;
    MoviesDetail({this.results});
  

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Center(
       child: Container(
         child: Column(
           children: <Widget>[
             Stack(
               children: <Widget>[
                 Container(
                   height: 400.0,
                   child: Center(
                     child: Image.network("https://image.tmdb.org/t/p/w200${this.results.posterPath}",
                     fit: BoxFit.fill,),
                   ),
                 ),
                 AppBar(
                   leading: InkWell(
                     onTap: (){
                       Navigator.pop(context);
                       
                     },
                     child: Icon(Icons.arrow_back),
                   ),
                 )
               ],
             ),
             Column(children: <Widget>[
               Text(this.results.title,
               style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
               const SizedBox(height: 13,),
               Text(this.results.overview)
             ],
             ),
             const SizedBox(height: 20,),
             Row(children: <Widget>[
               Text("Release Date.${this.results.releaseDate}")
             ],)
           ],
         ),
       ),

     ),
   );
  }}

  