# flask app.py

# Import the flask module
from flask import Flask, render_template, request, jsonify
import socket

# Create a Flask constructor. It takes name of the current module as the argument
app = Flask(__name__, template_folder='templates')

container_id = socket.gethostname()

@app.route('/')
def hello_world():
    return render_template('index.html', container_id=container_id)

@app.route('/cache-me')
def cache():
	return "nginx will cache this response"

@app.route('/info')
def info():
	resp = {
		'connecting_ip': request.headers['X-Real-IP'],
		'proxy_ip': request.headers['X-Forwarded-For'],
		'host': request.headers['Host'],
		'user-agent': request.headers['User-Agent']
	}
	return jsonify(resp)

@app.route('/flask-health-check')
def flask_health_check():
	return "success"

if __name__ == '__main__':
    # call the run method
    app.run(debug=True, host='0.0.0.0', port=5000)
