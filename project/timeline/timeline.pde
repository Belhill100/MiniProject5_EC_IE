Table table;
ArrayList<Movie> movies;
int minYear = 1920;
int maxYear = 2023;
int timelineY = 300; // Posición en Y de la línea de tiempo
int circleRadius = 10; // Radio de cada burbuja

void setup() {
  size(1200, 600);
  table = loadTable("imdb_top_1000.csv", "header");
  movies = new ArrayList<Movie>();

  // Cargar datos de las películas
  for (TableRow row : table.rows()) {
    String title = row.getString("Series_Title");
    int year = row.getInt("Released_Year");
    float score = row.getFloat("IMDB_Rating");
    
    if (year >= minYear && year <= maxYear) {
      Movie movie = new Movie(title, year, score);
      movies.add(movie);
    }
  }
}

void draw() {
  // Fondo de degradado
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    stroke(lerpColor(color(100, 149, 237), color(255, 182, 193), inter));
    line(0, i, width, i);
  }

  // Dibujar la línea de tiempo con marcas
  stroke(200);
  strokeWeight(2);
  line(50, timelineY, width - 50, timelineY);

  // Marcas de la línea de tiempo
  for (int year = minYear; year <= maxYear; year += 5) {
    float x = map(year, minYear, maxYear, 50, width - 50);
    line(x, timelineY - 5, x, timelineY + 5);
    if (year % 10 == 0) { // Cada década
      textAlign(CENTER);
      fill(50);
      text(year, x, timelineY + 20);
    }
  }

  // Dibujar las burbujas de películas
  for (Movie movie : movies) {
    movie.display();
  }

  // Mostrar información cuando el mouse esté sobre una burbuja
  for (Movie movie : movies) {
    if (movie.isMouseOver()) {
      movie.displayInfo();
      break;
    }
  }
}

class Movie {
  String title;
  int year;
  float score;
  float x, y;
  float radius;
  color fillColor;
  boolean isHovered = false;

  Movie(String title, int year, float score) {
    this.title = title;
    this.year = year;
    this.score = score;
    this.x = map(year, minYear, maxYear, 50, width - 50);
    this.y = timelineY + random(-50, 50); // Posición aleatoria cerca de la línea de tiempo
    this.radius = map(score, 0, 10, 5, 15); // Tamaño según el puntaje
    this.fillColor = color(map(score, 0, 10, 255, 150), map(score, 0, 10, 100, 255), 200);
  }

  void display() {
    noStroke();
    if (isMouseOver()) {
      fill(255, 200); // Resplandor
      ellipse(x, y, radius * 2.5, radius * 2.5);
      isHovered = true;
    }
    
    fill(fillColor);
    ellipse(x, y, radius * 2, radius * 2);
  }

  boolean isMouseOver() {
    return dist(mouseX, mouseY, x, y) < radius;
  }

  void displayInfo() {
    fill(0, 150);
    noStroke();
    rect(mouseX + 10, mouseY - 30, 150, 50, 10); // Rectángulo con bordes redondeados

    fill(255);
    textAlign(LEFT, TOP);
    textSize(12);
    text("Título: " + title + "\nAño: " + year + "\nPuntaje: " + score, mouseX + 15, mouseY - 25);
  }
}
