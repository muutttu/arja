# flask app.py

# Import the flask module
from flask import Flask, render_template
import socket

# Create a Flask constructor. It takes name of the current module as the argument
app = Flask(__name__, template_folder='templates')

container_id = socket.gethostname()

@app.route('/')
def hello_world():
    return render_template('index.html', container_id=container_id)


if __name__ == '__main__':
    # call the run method
    app.run(debug=True, host='0.0.0.0', port=5000)
