from flask import Flask, render_template, request, jsonify

import redis
import json

import settings
from assets.assets import assets_blueprint
import os

app = Flask(__name__)
app.secret_key = 'SECRET'
app.config.from_object(settings)

app.register_blueprint(assets_blueprint)

r = redis.Redis()

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/paths/save', methods=['POST'])
def path_create():
    name = request.json['name']
    with open(os.path.join('paths', '%s.json' % name), 'w') as f:
        f.write(json.dumps(request.json))
    return 'ok'

@app.route('/paths/<name>')
def path_view(name):
    with open(os.path.join('paths', '%s.json' % name), 'r') as f:
        return f.read()

@app.route('/smooth', methods=['POST'])
def smooth():
    x = request.json['x'] / 2
    y = request.json['y']

    print x, y

    return jsonify({ 'x'  : x, 'y' : y})

if __name__ == '__main__':
    app.run(debug=True)
