#include <stdio.h>
#include <stdlib.h>

/* Estructura para guardar cada medición*/
typedef struct{
    int anio;
    float valor;
} Medicion;

int main(void){

    int n;

    /**
     * Se leen la cantidad de registros, es la primera linea del stdin.
     * scanf decuelve la cantidad de campos leidos correctamente
     */
    if(scanf("%d", &n) != 1){
        fprintf(stderr, "Error: no se pudo leer la cantidad de registros\n");
        return 1;
    }

    /* Se reserva memoria para n mediciones */
    Medicion* mediciones = malloc(n * sizeof(Medicion));
    if(mediciones == NULL){
        fprintf(stderr, "Error: no se pudo reservar memoria\n");
        return 1;
    }

    // Se leen las mediciones, cada una con su año y valor
    for(int i = 0; i < n; i++){
        if(scanf("%d %f", &mediciones[i].anio, &mediciones[i].valor) != 2){
            fprintf(stderr, "Error: no se pudo leer la medición %d\n", i);
            return 1;
        }
    }

    // Mostramos los datos recibidos
    printf("Indice GINI de Argentina\n");
    printf("%-8s %-10s\n", "Anio", "GINI");                                  
    printf("--------------------\n");

    for(int i = 0; i < n; i++){
        printf("%-8d %4f\n", mediciones[i].anio, mediciones[i].valor);
    }

    free(mediciones);
    return 0;
}
