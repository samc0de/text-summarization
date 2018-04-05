FROM ubuntu:16.04
MAINTAINER Sameer Mahabole <sameer.mahabole@gmail.com>

# RUN apt-get update && yes | apt-get upgrade
#
# RUN apt-get install --yes curl python-pip
RUN apt-get update && apt-get install --yes curl python-pip

# For bazel.
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add -

# RUN apt-get update && yes | apt-get upgrade

# Install bazel.
RUN apt-get update && apt-get install --yes openjdk-8-jdk bazel
# RUN apt-get install --yes openjdk-8-jdk bazel

# RUN apt-get update && apt-get install --yes bazel

# RUN apt-get upgrade --yes bazel

# For development and debugging.
RUN set -e; \
        apt-get install --yes\
                vim \
                git \
                byobu \
        ;

# Fix old pip.
RUN pip install --upgrade pip

# Not sure if this is needed.
# RUN set -e; python -m pip install pandas==0.21.0 --force-reinstall --upgrade \
# --no-deps --no-cache --find-links \
# https://3f23b170c54c2533c070-1c8a9b3114517dc5fe17b7c3f8c63a43.ssl.cf2.rackcdn.com/ \
# --no-index

# Set the working directory to /app.
WORKDIR /app

# Copy the current directory contents into the container at /app.
ADD ./textsum /app/textsum
ADD ./requirements.txt /app
# This is so called 'toy data'. We might need to add a much larger amount of
# data, but only necessary, for now we're just testing, so the toy data is
# fine.
ADD ./textsum/data /app/data
# We also need logs/ and data/ dirs in the container, but first we need to
# confirm that the changes in logs need to be version controlled or does it
# make sense to reuse those. Same goes with the WORKSPACE file, so for now
# we're passing them as volumes.

# # Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt
RUN pip install --upgrade tensorflow
#
# RUN python extracter_script.py raw_data/foods.txt extracted_data/review_summary.csv
