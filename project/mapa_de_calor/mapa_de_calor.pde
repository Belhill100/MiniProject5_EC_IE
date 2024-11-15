Table table;
String[] genres;
int minYear = 1920;
int maxYear = 2023;
int[][] heatMap;
int cellWidth = 10;
int cellHeight = 20;

void setup() {
  size(1200, 800);
  table = loadTable("imdb_top_1000.csv", "header");
  
  // Crear una lista de géneros únicos
  ArrayList<String> genreList = new ArrayList<String>();
  for (TableRow row : table.rows()) {
    String genreListStr = row.getString("Genre");
    String[] genreArray = genreListStr.split(", ");
    for (String genre : genreArray) {
      genre = genre.trim();
      if (!genreList.contains(genre)) {
        genreList.add(genre);
      }
    }
  }
  genres = genreList.toArray(new String[genreList.size()]);
  
  // Inicializar la matriz de conteo (género x año)
  heatMap = new int[genres.length][maxYear - minYear + 1];
  
  // Contar películas por género y año
  for (TableRow row : table.rows()) {
    int year = row.getInt("Released_Year");
    String genreListStr = row.getString("Genre");
    String[] genreArray = genreListStr.split(", ");
    
    if (year >= minYear && year <= maxYear) {
      for (String genre : genreArray) {
        genre = genre.trim();
        int genreIndex = indexOf(genre);
        int yearIndex = year - minYear;
        if (genreIndex >= 0) {
          heatMap[genreIndex][yearIndex]++;
        }
      }
    }
  }
  
  // Dibujar el mapa de calor
  noLoop();
}

void draw() {
  background(255);
  
  for (int i = 0; i < genres.length; i++) {
    for (int j = 0; j < (maxYear - minYear + 1); j++) {
      int count = heatMap[i][j];
      float intensity = map(count, 0, maxCount(), 0, 255);
      fill(255 - intensity, 0, 0); // Más rojo para mayor conteo
      rect(j * cellWidth, i * cellHeight, cellWidth, cellHeight);
    }
  }
  
  // Etiquetas de géneros y años
  fill(0);
  textAlign(LEFT, CENTER);
  for (int i = 0; i < genres.length; i++) {
    text(genres[i], (maxYear - minYear + 1) * cellWidth + 10, i * cellHeight + cellHeight / 2);
  }
  
  textAlign(CENTER, TOP);
  for (int j = 0; j < (maxYear - minYear + 1); j++) {
    text(minYear + j, j * cellWidth, genres.length * cellHeight + 5);
  }
}

// Encontrar el índice de un género
int indexOf(String genre) {
  for (int i = 0; i < genres.length; i++) {
    if (genres[i].equals(genre)) return i;
  }
  return -1;
}

// Encontrar el conteo máximo en la matriz para normalizar la intensidad
int maxCount() {
  int max = 0;
  for (int i = 0; i < genres.length; i++) {
    for (int j = 0; j < (maxYear - minYear + 1); j++) {
      if (heatMap[i][j] > max) {
        max = heatMap[i][j];
      }
    }
  }
  return max;
}
