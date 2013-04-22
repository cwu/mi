from flask import Flask, render_template

import redis

import settings
from assets.assets import assets_blueprint

app = Flask(__name__)
app.secret_key = 'SECRET'
app.config.from_object(settings)

app.register_blueprint(assets_blueprint)

r = redis.Redis()

@app.route('/')
def index():
  return render_template('index.html')


if __name__ == '__main__':
  app.run(debug=True)
