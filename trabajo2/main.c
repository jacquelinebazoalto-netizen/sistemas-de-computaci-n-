#include <stdio.h>
#include <stdlib.h>

/* Rutina de ensamblador: convierte float a entero y le suma 1 */
extern int convertir_gini(float valor);

typedef struct{
    int anio;
    float valor;
} Medicion;

int main(void){

    int n;

    if(scanf("%d", &n) != 1){
        fprintf(stderr, "Error: no se pudo leer la cantidad de registros\n");
        return 1;
    }

    Medicion* mediciones = malloc(n * sizeof(Medicion));
    if(mediciones == NULL){
        fprintf(stderr, "Error: no se pudo reservar memoria\n");
        return 1;
    }

    for(int i = 0; i < n; i++){
        if(scanf("%d %f", &mediciones[i].anio, &mediciones[i].valor) != 2){
            fprintf(stderr, "Error: no se pudo leer la medicion %d\n", i);
            free(mediciones);
            return 1;
        }
    }

    printf("Indice GINI de Argentina\n");
    printf("%-8s %-10s %-15s\n", "Anio", "GINI (float)", "GINI+1 (entero)");
    printf("----------------------------------------\n");

    for(int i = 0; i < n; i++){
        int convertido = convertir_gini(mediciones[i].valor);
        printf("%-8d %-10.6f %-15d\n",
               mediciones[i].anio,
               mediciones[i].valor,
               convertido);
    }

    free(mediciones);
    return 0;
}
