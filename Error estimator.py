# -*- coding: utf-8 -*-
"""
Created on Mon Nov 11 17:56:35 2019

@author: Takuya
"""

# exercise 8.1.2
import nltk
import matplotlib.pyplot as plt
import numpy as np
from scipy.io import loadmat
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from toolbox_02450 import rocplot, confmatplot
from urllib import request
import pandas as pd
import array
from numpy import linalg as LA
from sklearn.neighbors import KNeighborsClassifier

def base_err_estimator(X_train,y_train,X_test,y_test):
    mu = np.mean(X_train, 0)
    sigma = np.std(X_train, 0)
    
    X_train = (X_train - mu) / sigma
    
    if(np.mean(y_train)>0.5):
        y_pred=np.array([1 for n in range(len(y_test))])
    else:
        y_pred=np.array([0 for n in range(len(y_test))])
    
    return np.sum(y_pred != y_test) / len(y_test)



def log_err_estimator(X_train,y_train,X_test,y_test,lam):   
    mu = np.mean(X_train, 0)
    sigma = np.std(X_train, 0)
    
    X_train = (X_train - mu) / sigma
    X_test = (X_test - mu) / sigma
    

    mdl = LogisticRegression(penalty='l2', C=1/lam )
    
    mdl.fit(X_train, y_train)

    y_test_est = mdl.predict(X_test).T

    return np.sum(y_test_est != y_test) / len(y_test)


    
def KNN_err_estimator(X_train,y_train,X_test,y_test,n): 
    mu = np.mean(X_train, 0)
    sigma = np.std(X_train, 0)
    
    X_train = (X_train - mu) / sigma
    X_test = (X_test - mu) / sigma  
    
    knc = KNeighborsClassifier(n_neighbors=n)
    knc.fit(X_train, y_train)
    
    score = knc.score(X_test, y_test)
    
    return 1-score



font_size = 15
plt.rcParams.update({'font.size': font_size})

#######################################################################
url="https://archive.ics.uci.edu/ml/machine-learning-databases/00477/Real%20estate%20valuation%20data%20set.xlsx"
df=pd.read_excel("https://archive.ics.uci.edu/ml/machine-learning-databases/00477/Real%20estate%20valuation%20data%20set.xlsx",encoding='utf8')

# using only house age 
X=np.array(df.iloc[:,1:-1].values.tolist())
y=np.array(df.iloc[:,-1].tolist())
attributeNames=list(df)[1:]
y_est=np.array([1*(v-np.mean(X)<0) for v in X])
y=np.array([1*(v-np.mean(y)>0) for v in y])
N, M = X.shape



# Create crossvalidation partition for evaluation
# using stratification and 95 pct. split between training and test 
K1=10
CV1 = model_selection.KFold(K1, shuffle=True)
K2=5
CV2 = model_selection.KFold(K2, shuffle=True)

#parameter
lambda_interval = np.logspace(-3, 4, 500)
N=31

base_err_rate=np.zeros(K1)
log_err_rate=np.zeros((K1,len(lambda_interval)))
KNN_err_rate=np.zeros((K1,N))

i=0
for train_index_outer, test_index_outer in CV1.split(X,y):
    X_train_outer = X[train_index_outer]
    y_train_outer = y[train_index_outer]
    X_test_outer = X[test_index_outer]
    y_test_outer = y[test_index_outer]
    for train_index_inner, test_index_inner in CV2.split(X_train_outer,y_train_outer):
        X_train_inner = X[train_index_inner]
        y_train_inner = y[train_index_inner]
        X_test_inner = X[test_index_inner]
        y_test_inner = y[test_index_inner]
        
        base_err_rate[i]+=base_err_estimator(X_train_inner,y_train_inner,X_test_inner,y_test_inner)/K2
        for j in range(len(lambda_interval)):
            log_err_rate[i,j]+=log_err_estimator(X_train_inner,y_train_inner,X_test_inner,y_test_inner,lambda_interval[j])/K2
            
        for j in range(1,N):
            KNN_err_rate[i,j]+=KNN_err_estimator(X_train_inner,y_train_inner,X_test_inner,y_test_inner,j)/K2
        
    i+=1

print(base_err_rate)
opt_log_err_rate=[(np.argmin(log_err_rate[i]),log_err_rate[i][np.argmin(log_err_rate[i])]) for i in range(len(log_err_rate))]
print(opt_log_err_rate)
opt_KNN_err_rate=[(np.argmin(KNN_err_rate[i][1:])+1,np.min(KNN_err_rate[i][1:])) for i in range(0,len(KNN_err_rate))]
print(opt_KNN_err_rate)

    
