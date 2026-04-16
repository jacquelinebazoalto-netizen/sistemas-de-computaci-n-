import requests
import subprocess
import json

URL = "https://api.worldbank.org/v2/country/AR/indicator/SI.POV.GINI"

def fetch_gini():
    # Los parametros de la request van a ser: formaato JSON, ultimas 10 mediciones
    params = {
        "format": "json",
        "mrv": 10
    }

    response = requests.get(URL, params=params)
    response.raise_for_status() # Lanza excepción si el status code no es 200

    data = response.json()

    # El resultado es una lista de dos elementos, el segundo elemento es la lista de mediciones
    mediciones = data[1]

    # Se van a filtrar los registros que tiene valor, algunos años no tienen dato (null)
    registros = [
        (entry["date"], entry["value"])
        for entry in mediciones
        if entry["value"] is not None
    ]

    return registros

def enviar_a_c(registros):
    # Se construye el texto que se le va a enviar a C por stdin
    # Formato: una linea por medicion "año valor"
    # se utilizara float con 6 decimales para que C lo lea fácilmente por scanf
    lineas = []

    # Lo primero sera la cantidad de registros, para que C sepa cuantas lineas va a leer
    lineas.append(str(len(registros)))

    for anio, valor in registros:
        lineas.append(f"{anio} {valor:.6f}")

    texto = "\n".join(lineas) + "\n" # se agrega un salto de linea al final para que C sepa que termino la entrada

    # Se llama al programa C usando subprocess, se le pasa el texto por stdin
    proceso = subprocess.run(
        ["./gini_c"], # se tiene que compilar el programa en C y se tiene que llamar gini_c
        input=texto,
        text=True
    )

if __name__ == "__main__":
    registros = fetch_gini()
    enviar_a_c(registros)

