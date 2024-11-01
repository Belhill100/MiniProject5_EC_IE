// Variables para almacenar los puntajes y colores
Table table;
ArrayList<Float> metaScores = new ArrayList<Float>();
color[] colors = new color[5]; // 5 rangos de color
int batchSize = 200;    // Tamaño del lote
int currentIndex = 0;   // Índice inicial para el lote actual
int lastBatchTime = 0;  // Tiempo en que se dibujó el último lote
int interval = 2000;   // Intervalo en milisegundos (10 segundos)

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
    dibujarTriangulos(currentIndex, currentIndex + batchSize);
    currentIndex += batchSize;    // Avanza al siguiente lote
    lastBatchTime = millis();     // Actualiza el tiempo del último lote

    // Reinicia cuando se han procesado todos los datos
    if (currentIndex >= metaScores.size()) {
      noLoop(); // Detener draw() una vez que todos los datos están procesados
    }
  }
}

void cargarPuntajes() {
  // Carga los puntajes Meta_score en el ArrayList
  for (TableRow row : table.rows()) {
    float score = row.getFloat("Meta_score");
    metaScores.add(score);
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
  println(indice);
  return colors[indice];
}

void dibujarTriangulos(int start, int end) {
  background(255);  // Limpia la pantalla antes de dibujar el nuevo lote

  for (int i = start; i < end && i < metaScores.size(); i++) {
    float score = metaScores.get(i);
    color c = obtenerColorPorPuntaje(score);
    fill(c);
    noStroke();
    
    // Posición y tamaño para los triángulos
    float x = random(width);
    float y = random(height);
    float size = map(score, 0, 10, 1, 5);
    
    // Dibuja el triángulo
    triangle(x, y, x + size, y, x + size / 2, y - size);
  }
}
