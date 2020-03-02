# -*- coding: utf-8 -*-

import keras 
import numpy as np
import pandas as pd

import cnn_datasplit
import index_generator

def run_CNN_experiment(k,data,index):
	n=int(100/k)

	
	acc=np.array([])

	for x in range(k):
		print("Running experiment {}".format(x))
		acc_list=Neuralnet(data,index[x],n=n)
		acc=np.append(acc,acc_list)
	
	#Print result save as SCV file and return it
	print(CNN_acc)
	#CNN=pd.DataFrame({"CNN_acc":acc})
	print(CNN)
	#CNN.to_csv("CNN_acc")
	return acc

"""
Funktion for running a test of the neural network, 
return list of accuracy on one test set.
"""

def Neuralnet(data,index,n=5):
	
	#Find data in fold
	train,test,train_lable,test_lable=CNN_datasetup(data,index)
	
	#Setting up model
	model = keras.models.Sequential()
	model.add(keras.layers.Conv1D(#Convelutional layer 10 fetures 
	        100,kernel_size=10, input_shape=(100,3)))
	model.add(keras.layers.Conv1D(100,10,activation='relu'))
	model.add(keras.layers.MaxPooling1D(3))
	model.add(keras.layers.Conv1D(100,kernel_size=5,activation='relu'))
	model.add(keras.layers.Conv1D(160,10,activation='relu'))
	model.add(keras.layers.Conv1D(160,10,activation='relu'))
	model.add(keras.layers.Dropout(0.5))
	model.add(keras.layers.GlobalAveragePooling1D())
	model.add(keras.layers.Dense( #Output softmax layer
	        10,activation="softmax"))
	
	model.compile(loss="categorical_crossentropy",optimizer="adam",metrics=['accuracy'])
	#print(model-summary()) #print model stucture
	
	#Train the model
	model.fit(train,train_lable,epochs=3,batch_size=5,verbose=1,validation_split=0.2)
	
	#Get prediction on test set
	predict=model.predict(test)
	
	acc_list=np.zeros(n)
	#Compere predicted lable with true lable 
	for i in range(n):
		acc_list[i]=np.argmax(predict[i])==np.argmax(test_lable[i])
	print("experiment accurcy{}, acc_liss={}, predicted {}, truelable{}"
	   .format(sum(acc_list)/n,acc_list,[ np.argmax(predict[i]) for i in range(n)],[ np.argmax(test_lable[i]) for i in range(n)]))
	return acc_list

"""
Input:
pandas data frame 
Index from k-meens

Output: 
train=90*3*100 matrix
test=10*10 binary 
"""
def CNN_datasetup(data,index):
    

	
	index_train=index[0]
	index_test=index[1]
	
	nTest=index_test.size
	nTrain=index_train.size
	
	train=np.empty([nTrain,100,3])
	test=np.empty([nTest,100,3])
    
	train_lable=np.zeros([nTrain,10])	
	test_lable=np.zeros([nTest,10])
	#print(index_test)
	#print(index_train)
	for i,j in enumerate(index_test):
		for n in range(100):
			test[i,n,0]=data.iloc[j*100+n,3]
			test[i,n,1]=data.iloc[j*100+n,4]
			test[i,n,2]=data.iloc[j*100+n,5]
		test_lable[i,data.iloc[j*100,1]-1]=1
		
	for i,j in enumerate(index_train):
		for n in range(100):
			train[i,n,0]=data.iloc[j*100+n,3]
			train[i,n,1]=data.iloc[j*100+n,4]
			train[i,n,2]=data.iloc[j*100+n,5]
		train_lable[i,data.iloc[j*100,1]-1]=1
	
	#print(train)
	#print(test)
	#print(test_lable)
	#print(train_lable)
	return train, test,train_lable,test_lable