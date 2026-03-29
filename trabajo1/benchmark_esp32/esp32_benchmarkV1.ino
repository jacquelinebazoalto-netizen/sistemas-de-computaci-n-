#include "esp_pm.h" // Para serCpuFrequencyMHz()

// Num de iteraciones de cada bucle
const long long ITER = 30000000LL; // 30 millones

void runBenchmark(uint32_t freqMHz) {
  // setteamos frecuencia
  setCpuFrequencyMhz(freqMHz);

  Serial.printf("  Frecuencia CPU: %u MHz\n", getCpuFrequencyMhz());
  Serial.printf("  Iteraciones   : %lld\n", ITER);
  Serial.printf("--------------------------------------------------\n");

  // Bucle de enteros
  volatile long long sumInt = 0; // volatile para que el compilador no lo optimice
  int64_t t0 = esp_timer_get_time(); // mide en µs desde el arranque para más precisión

  for(long long i = 0; i < ITER; i++) {
    sumInt += i;
  }

  int64_t tf = esp_timer_get_time();
  double tiempoEjecucion = (tf - t0) / 1e6;

  Serial.printf("[INT]  Suma                  : %lld\n", (long long)sumInt);
  Serial.printf("[INT]  Tiempo de ejecución   : %.3f s\n", tiempoEjecucion);
  Serial.printf("[INT]  MOPS                  : %.1f millones de ops/s\n\n", (double)ITER /tiempoEjecucion/1e6);

  // Bucle de flotantes
  volatile float sumFloat = 0.0f;
  int64_t t0f = esp_timer_get_time();

  for(long long i = 0; i < ITER; i++) {
    sumFloat += (float)i;
  }
  
  int64_t tff = esp_timer_get_time();
  double tiempoEjecucionFloat = (tff - t0f) / 1e6;

  Serial.printf("[FLOAT]  Suma                  : %lld\n", (double)sumFloat);
  Serial.printf("[FLOAT]  Tiempo de ejecución   : %.3f s\n", tiempoEjecucionFloat);
  Serial.printf("[FLOAT]  MOPS                  : %.1f millones de ops/s\n\n", (double)ITER /tiempoEjecucionFloat/1e6);

}

void setup() {
  Serial.begin(115200);
  // Espera hasta que el Serial Monitor esté abierto
  while (!Serial) { delay(10); }
  
  // Pausa extra para que termines de abrir el monitor
  delay(500);

  Serial.println("\n\n*** BENCHMARK ESP32 ***\n");

  // Corrida a 80 MHz
  runBenchmark(80);

  delay(1000);

  // Corrida a 160 MHz
  runBenchmark(160);

  Serial.println("====================================");
  Serial.println("  Benchmark terminado.");
}

void loop() {
  // Para repetir el benchmark presionar cualquier tecla
  if (Serial.available()) {
    while (Serial.available()) Serial.read();
    Serial.println("\nReiniciando benchmark...\n");
    runBenchmark(80);
    delay(500);
    runBenchmark(160);
  }
}