# Container base image (host OS)
FROM python:3.9-slim-buster

# Labels for container
LABEL version="0.0.1-beta"
LABEL author="muutttu"

# Set environment variables in the container
ENV LANG C.UTF-8

# upgrade pip
RUN pip install --upgrade pip

# Creates and sets the working directory in the container for further commands
WORKDIR /app

# Copy the App files to the current working directory
COPY ./files/requirements.txt \
    ./files/__init.py__ \
    ./files/app.py \
    ./files/wsgi.py \
    ./
# Copy templates-folder to app-folder
ADD templates /app/templates

# Install any dependencies
RUN apt-get -y update
RUN apt-get -y install python3-pip build-essential
RUN pip3 install -r requirements.txt

# Specify the command to run on container start
CMD ["gunicorn", "-w", "3", "-b", "0.0.0.0:5000", "-t", "360", "--reload", "wsgi:app"]

# Sets the image’s main command
#ENTRYPOINT ["python3"]