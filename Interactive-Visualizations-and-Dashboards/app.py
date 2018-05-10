from flask import (
    Flask, 
    request, 
    redirect, 
    jsonify, 
    render_template)
import pandas as pd
from sqlalchemy.orm import Session
from flask_sqlalchemy import SQLAlchemy

#Flask Setup
app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = "sqlite:///db/belly_button_biodiversity.sqlite"

db = SQLAlchemy(app)

@app.route("/")
def init():
    return render_template("index.html")

@app.route('/names')
def get_names():

    results = db.session.query(Metadata.sampleid)
    names = []
    for r in results:
        names.append(r.sampleid)
    return jsonify(names)

@app.route("/otu")
def otu():

    otu_desc = db.session.query(OTU.lowest_found).all()
    otu_descriptions = [i[0] for i in otu_desc]
    return jsonify(otu_descriptions)


@app.route('/metadata/<sample>')
def metadata(sample):

    results = db.session.query(Metadata.sampleid, 
                                Metadata.age, 
                                Metadata.bbtype,
                                Metadata.ethnicity,
                                Metadata.gender,
                                Metadata.location).all()
    dict1 = {}
    for k,p in results[0].__dict__.items():
        if ('AGE' in k or 'BBTYPE' in k or 'ETHNICITY' in k or 'GENDER' in k or 'LOCATION' in k or 'SAMPLEID' in k):
            dict1[k] = p

    return jsonify(dict1)


@app.route('/wfreq/<sample>')
def wfreq(sample):

    results = db.session.query(Metadata.sampleid, Metadata.wfreq)
    print(results)
    return jsonify(results[0][0])


@app.route('/samples/<sample>')
def samples(sample):
    
    df_sample = df_samples[ ['otu_id',sample] ]
    df_sample = df_sample.sort_values(by=sample,axis=0,ascending=False)
    #convert int to str so that we can jsonify the data
    df_sample['otu_id']  = df_sample['otu_id'].apply(lambda x: str(x))
    df_sample[sample] = df_sample[sample].apply(lambda x: str(x))
    result = {}
    for k in df_sample.keys():
        result[k] = list(df_sample[k])
    
    return jsonify(result)

if __name__ == "__main__":
    app.run(debug=False)















