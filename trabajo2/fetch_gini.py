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

if __name__ == "__main__":
    registros = fetch_gini()

