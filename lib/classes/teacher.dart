class Teacher {
  late String anrede;
  late String vorname;
  late String nachname;
  late String kuerzel;
  late String faecher;
  late String email;

  Teacher({
    required this.anrede,
    required this.vorname,
    required this.nachname,
    required this.kuerzel,
    required this.faecher,
    required this.email,
  });

  Teacher.fromJson(var json, int index) {
    anrede = json[index]['anrede'];
    vorname = json[index]['vorname'];
    nachname = json[index]['nachname'];
    kuerzel = json[index]['kuerzel'];
    faecher = json[index]['faecher'];
    email = json[index]['email'];
  }
}