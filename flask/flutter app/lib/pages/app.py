from flask import Flask, request, Response
from keras.preprocessing import image
from tensorflow.keras.models import load_model
import simplejson as json
import numpy as np
import cv2

app = Flask(__name__)


@app.route('/', methods=["GET", "POST"])
def index():

    f = request.files['image']
    f.save("./deploy/images/" + f.filename)
    # print("**********FILE PATH*******"+f.name,file=sys.stderr);
    img = cv2.imread("./deploy/images/" + f.filename)
    cv2.imwrite("dd1.jpg", img)
    imgresized = cv2.resize(img, (224, 224))

    # image = request.files['image']
    # c = request.files['class']
    # if(c=="LadysFinger"):
    model = load_model('./deploy/BringalFinal.h5')
    res = model.predict(np.array(imgresized).reshape(1, 224, 224, 3))
    final = "Thrla"
    if res == 0:
        final = "LadysFinger"
    else:
        final = "Weed"
    # if(c=="Brinjal"):
    #     model = load_model('brinjal.h5')
    #     res=model.predict(np.array(imgresized).reshape(1,224,224,3))
    #     if res==0:
    #         final="Brinjal"
    #     else:
    #         final="Weed"
    data = {
        'name': final
    }

    js = json.dumps(data)
    res = Response(js, status=200, mimetype='application/json')
    return res


if __name__ == '__main__':
    app.run(host="localhost", port=5000)
