# from flask import
import os
import tensorflow as tf
from flask import Flask, request, url_for, Response
from keras.preprocessing.image import ImageDataGenerator, load_img, img_to_array
import simplejson as json
import numpy as np
import argparse
import imutils
import cv2
import time
import uuid
import base64

IMG_SHAPE = 224
model_path_Ladys = 'models/LadysFingerFinal.h5'
model_path_Bringal = 'models/BringalFinal.h5'

ALLOWED_EXTENSIONS = set(['jpg', 'jpeg'])


def get_as_base64(url):
    return base64.b64encode(request.get(url).content)


def predict(name, file2):

    print(file2)
    img_pre = cv2.imread(file2, cv2.IMREAD_UNCHANGED)
    img_pre = cv2.resize(img_pre, (IMG_SHAPE, IMG_SHAPE))
    if (name == "LadysFinger"):

        model = tf.keras.models.load_model(model_path_Ladys)
        print("GPUS are working hard...")
        result = model.predict_classes(np.reshape(
            img_pre, (-1, IMG_SHAPE, IMG_SHAPE, 3)))
        print(result)

        if result[0] == 1:
            print("Weed")
            result = "weed"
        else:
            print("Crop")
            result = 'LadysFinger'
        print("Huh ! Lot of work..")
    if (name == "Bringal"):

        model = tf.keras.models.load_model(model_path_Bringal)
        print("GPUS are working hard...")
        result = model.predict_classes(np.reshape(
            img_pre, (-1, IMG_SHAPE, IMG_SHAPE, 3)))
        print(result)

        if result[0] == 1:
            print("Weed")
            result = "weed"
        else:
            print("Crop")
            result = 'Brinjal'
        print("Huh ! Lot of work..")

    return result


def my_random_string(string_length=10):
    """Returns a random string of length string_length."""
    random = str(uuid.uuid4())  # Convert UUID format to a Python string.
    random = random.upper()  # Make all characters uppercase.
    random = random.replace("-", "")  # Remove the UUID '-'.
    return random[0:string_length]  # Return the random string.


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS


app = Flask(__name__)
@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        import time
        start_time = time.time()
        file = request.files['image']
        name = request.form.get('name')
        print("ddddd", name)
        if file and allowed_file(file.filename):
            filename = file.filename

            file_path = os.path.join("./images/", filename)
            print(file_path)
            file.save(file_path)
            result = predict(name, file_path)

            print(result)
            print(file_path)
            filename = my_random_string(6) + filename

            os.rename(file_path, os.path.join(
                "./images/", filename))
            print("--- %s seconds ---" % str(time.time() - start_time))
            data = {

                'result': result

            }

            js = json.dumps(data)
            res = Response(js, status=200, mimetype='application/json')
            return res


if __name__ == "__main__":
    app.run()
