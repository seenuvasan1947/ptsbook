class DataLists {
  final List<String> bookname;
  final List<String> authorname;
  final List<int> no_of_episode;
  final List<DateTime> published_date;
  final List<String> file_url;
  final List<String> imageurl ;

  DataLists(this.bookname, this.authorname, this.no_of_episode,this.published_date,this.file_url,this.imageurl);
}

class UserDataLists {
  final List<String> bookname;
  final List<String> authorname;

  final List<String> shortdisc;
  final List<String> longdisc ;

  UserDataLists(this.bookname, this.authorname,this.shortdisc,this.longdisc);
}
