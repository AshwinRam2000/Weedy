from flask import Flask, request, Response
from keras.preprocessing import image
from tensorflow.keras.models import load_model
import simplejson as json
import numpy as np
import cv2

app = Flask(__name__)


@app.route('/', methods=["GET", "POST"])
def index():
    # f = open("url.txt")

    # img = cv2.imread(".jpg")
    # imgresized = cv2.resize(img,(224,224))
    # if request.method == 'POST':
    #     image = request.files['image']
    #     c = request.files['class']
    # if(c=="LadysFinger"):
    #     model = load_model('model.h5')
    #     res=model.predict(np.array(imgresized).reshape(1,224,224,3))
    #     if res==0:
    #         final="LadysFinger"
    #     else:
    #         final="Weed"
    # if(c=="Brinjal"):
    #     model = load_model('brinjal.h5')
    #     res=model.predict(np.array(imgresized).reshape(1,224,224,3))
    #     if res==0:
    #         final="Brinjal"
    #     else:
    #         final="Weed"
    # f = request.files['image']
    # f.save(f.filename))
    data = {
        'class': str(request.files['image'])
    }

    js = json.dumps(data)
    res = Response(js, status=200, mimetype='application/json')
    return res


if __name__ == '__main__':
    app.run()
