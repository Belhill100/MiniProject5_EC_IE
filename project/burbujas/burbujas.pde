Table table;
ArrayList<Bubble> bubbles;

void setup() {
  size(800, 600);
  table = loadTable("imdb_top_1000.csv", "header");
  bubbles = new ArrayList<Bubble>();
  
  for (TableRow row : table.rows()) {
    String title = row.getString("Title");
    float score = row.getFloat("IMDB Score");
    String genre = row.getString("Genre");
    int year = row.getInt("Year");
    
    Bubble b = new Bubble(title, genre, score, year);
    bubbles.add(b);
  }
}

void draw() {
  background(255);
  for (Bubble b : bubbles) {
    b.display();
  }
}

class Bubble {
  String title, genre;
  float score;
  int year;
  float x, y, size;
  
  Bubble(String title, String genre, float score, int year) {
    this.title = title;
    this.genre = genre;
    this.score = score;
    this.year = year;
    this.size = map(score, 0, 10, 10, 50); // Tamaño basado en puntaje
    
    // Posición inicial de cada burbuja
    this.x = map(year, 1920, 2023, 50, width - 50);
    this.y = map(genre.hashCode(), -2147483648, 2147483647, 50, height - 50); // posición Y por género
  }
  
  void display() {
    noStroke();
    fill(100, 150, 200, 150);
    ellipse(x, y, size, size);
    fill(0);
    textAlign(CENTER);
    text(title, x, y + size / 2 + 10);
  }
}
