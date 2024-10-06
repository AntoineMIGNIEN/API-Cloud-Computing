from flask import Flask, request, render_template
from azure.storage.blob import BlobServiceClient
import os

app = Flask(__name__)

# .env pour la connexion au Blob Storage
connect_str = f"DefaultEndpointsProtocol=https;AccountName={os.getenv('ACCOUNT_NAME')};AccountKey={os.getenv('ACCOUNT_KEY')};EndpointSuffix=core.windows.net"
container_name = "blob-container-api-cc"

# Créer un client pour le service de stockage
blob_service_client = BlobServiceClient.from_connection_string(connect_str)

def push_to_blob(data):
    try:
        #Randomiser le nom du blob
        blob_name = str(os.urandom(5).hex()) + ".txt"

        # Créer un client pour le conteneur
        container_client = blob_service_client.get_container_client(container_name)

        # Push la chaîne de caractères dans le blob
        blob_client = container_client.get_blob_client(blob_name)
        blob_client.upload_blob(data, overwrite=True)
        print("Push done !")

    except Exception as e:
        print(f"Erreur lors de l'upload vers le Blob : {e}")


@app.route('/')
def list_blobs():
    try:
        # Récupérer le conteneur
        container_client = blob_service_client.get_container_client(container_name)

        # Lister les blobs du conteneur
        blob_list = container_client.list_blobs()

        # Filtrer les blobs qui ont .txt et stocker leurs contenu dans une liste
        txt_blobs = []
        for blob in blob_list:
            if blob.name.endswith('.txt'):
                blob_client = container_client.get_blob_client(blob)
                texte = blob_client.download_blob().readall().decode('utf-8')
                date = container_client.get_blob_client(blob).get_blob_properties().last_modified.strftime("%Y-%m-%d %H:%M:%S")
                all_string = f"Date de dernière modification : {date}, Contenu : {texte}"
                txt_blobs.append(all_string)

        return render_template('index.html', blobs=txt_blobs)

    except Exception as e:
        print(f"Erreur lors de la récupération des blobs : {e}")
        return "Erreur lors de la récupération des blobs"

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        user_input = request.form['user_input']
        push_to_blob(user_input)

        return 'Push Done !'

    return render_template('./index.html')

if __name__ == '__main__':
    app.run(debug=True)
