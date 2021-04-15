FROM 754180621461.dkr.ecr.eu-west-1.amazonaws.com/eks/python:3.9-alpine
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 5000
CMD python ./index.py
