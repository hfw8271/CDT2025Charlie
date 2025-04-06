from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    return render_template("index.html")

@app.route('/map')
def map_page():
    return render_template("map.html")

@app.route('/tickets')
def tickets():
    return render_template("tickets.html")

@app.route('/safety')
def safety():
    return render_template("safety.html")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)