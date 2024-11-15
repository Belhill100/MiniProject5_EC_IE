// Variables para almacenar los puntajes y colores
Table table;
ArrayList<Float> metaScores = new ArrayList<Float>();
ArrayList<Float> imdbRatings = new ArrayList<Float>();
color[] colors = new color[5]; // 5 rangos de color
int batchSize = 50;    // Tamaño del lote
int currentIndex = 0;   // Índice inicial para el lote actual
int lastBatchTime = 0;  // Tiempo en que se dibujó el último lote
int interval = 20000;    // Intervalo en milisegundos (10 segundos)
float expansionRatio = 0.1; // Incremento del 10%

void setup() {
  size(1300, 650);
  table = loadTable("imdb_top_1000.csv", "header"); // Cargar la tabla
  cargarPuntajes();
  definirColores();
  background(255);
}

void draw() {
  // Verifica si han pasado 10 segundos desde el último lote
  if (millis() - lastBatchTime > interval) {
    lastBatchTime = millis();     // Actualiza el tiempo del último lote
    currentIndex += batchSize;    // Avanza al siguiente lote

    // Reinicia cuando se han procesado todos los datos
    if (currentIndex >= metaScores.size()) {
      noLoop(); // Detener draw() una vez que todos los datos están procesados
    }
  } else {
    // Llama a dibujarCirculos con el ratio de expansión actual
    float ratio = map(millis() - lastBatchTime, 0, interval, 0, 1);
    dibujarCirculos(currentIndex, currentIndex + batchSize, ratio);
  }
}

void cargarPuntajes() {
  // Carga los puntajes Meta_score e IMDB_Rating en los ArrayLists
  for (TableRow row : table.rows()) {
    float score = row.getFloat("Meta_score");
    float rating = row.getFloat("IMDB_Rating");
    metaScores.add(score);
    imdbRatings.add(rating);
  }
}

void definirColores() {
  // Define colores para cada rango de puntaje
  colors[0] = color(255, 0, 0); // Rojo para puntajes bajos
  colors[1] = color(255, 128, 0); // Naranja
  colors[2] = color(255, 255, 0); // Amarillo
  colors[3] = color(0, 255, 0); // Verde claro
  colors[4] = color(0, 128, 255); // Azul para puntajes altos
}

color obtenerColorPorPuntaje(float score) {
  // Divide el rango 0-10 en cinco partes iguales y asigna un color
  int indice = int(map(score, 0, 10, 0, 5)); // Mapear directamente a 5 rangos de 0 a 4
  indice = constrain(indice, 0, 4); // Asegurar que los índices estén en el rango 0 a 4
  return colors[indice];
}

void dibujarCirculos(int start, int end, float ratio) {
  background(255);  // Limpia la pantalla antes de dibujar el nuevo lote

  for (int i = start; i < end && i < metaScores.size(); i++) {
    float score = metaScores.get(i);
    float rating = imdbRatings.get(i);
    color c = obtenerColorPorPuntaje(score);
    fill(c);
    noStroke();
    
    // Posición aleatoria para los círculos
    float x = random(width);
    float y = random(height);
    
    // Cálculo del radio mínimo y máximo en base a Meta_score y IMDB_Rating, con reducción al 50%
    float minRadius = map(score, 0, 10, 2.5, 10);       // Radio mínimo reducido a la mitad
    float maxRadius = map(rating, 0, 10, minRadius, 20); // Radio máximo reducido a la mitad
    
    // Cálculo del radio con expansión gradual
    float radius = lerp(minRadius, maxRadius, ratio);

    // Dibuja el círculo con el radio oscilante
    ellipse(x, y, radius * 2, radius * 2);
  }
}
