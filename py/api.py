import os
import requests
import json
import time
from pathlib import Path


def upload_files_to_dataset(dataset_DOI: str,
                            file_paths: dict,
                            BASE_URL: str = os.getenv("BASE_URL"),
                            API_TOKEN: str = os.getenv("API_TOKEN"),
                            verbose: bool = True):

    url = f"{BASE_URL}/api/datasets/:persistentId/add?persistentId={dataset_DOI}"
    headers = {'X-Dataverse-key': API_TOKEN}
    not_uploaded = []

    for i, (directory_label, file_path) in enumerate(file_paths.items()):
        path_obj = Path(file_path)

        json_data = {
            "description": "",
            "directoryLabel": directory_label,
            "restrict": "false",
            "tabIngest": "true"
        }

        try:
            start_time = time.time()

            with open(file_path, 'rb') as f:
                files = {
                    'file': (path_obj.name, f),
                    'jsonData': (None, json.dumps(json_data), 'application/json')
                }

                response = requests.post(url, headers=headers, files=files)

            elapsed_time = time.time() - start_time
            file_size = os.path.getsize(file_path) / (1024**2)
            upload_speed = file_size / elapsed_time

            if response.status_code != 200:
                not_uploaded.append(file_path)
                print(f"Failed: {file_path} | {response.status_code} - {response.text}")
            elif verbose:
                print(f"[{i+1}/{len(file_paths)}] Uploaded {path_obj.name} "
                      f"({round(file_size,2)} MB in {round(elapsed_time,2)}s @ "
                      f"{round(upload_speed,2)} MB/s) to {directory_label}")

        except Exception as e:
            not_uploaded.append(file_path)
            print(f"Error uploading {file_path}: {str(e)}")

    return not_uploaded


# /!\ mettre dans un .env sinon garder ici mais attention à ne pas
# partager le script sur git par exemple
# Trouver votre jeton API ici :
# https://entrepot.recherche.data.gouv.fr/dataverseuser.xhtml?selectTab=apiTokenTab
API_TOKEN = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
BASE_URL = "https://entrepot.recherche.data.gouv.fr"
###


dataset_DOI = "doi:xx.xxxxx/xxxxxx"
file_paths = {
    "raw_data": "data/file1.csv",
    "processed": "output/results.csv",
    "figures": "plots/figure1.png"
}

failures = upload_files_to_dataset(
    dataset_DOI=dataset_DOI,
    file_paths=file_paths,
    BASE_URL=BASE_URL,
    API_TOKEN=API_TOKEN
)
