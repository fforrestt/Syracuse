##########################################################################################################################
'''
Tornado Analysis
Dataset cleaning/Individual States Dataframes/LTSM Model with predictors and graphing
'''

#set path/csv file
os.chdir('C:/Users/forrest/Desktop/schoo/IST 718 - Big Data Analysis/finalproject')
dff = pd.read_csv(r'Project Dataset.csv') 
nn = dff

#months to numeric
months = {'MONTH_NAME' : {'January':1, 'February':2, 'March':3, 'April':4,'May':5, 'June':6, 'July':7
                          ,'August':8, 'September':9, 'October':10, 'November':11, 'December':12}}
nn = nn.replace(months)
nn = nn.fillna(0)
nn.info()
#date column
nn.rename(columns = {'MONTH_NAME':'MONTH', 'BEGIN_DAY':'DAY'}, inplace = True)
nn['date'] = pd.to_datetime(nn[['DAY', "MONTH", "YEAR"]])
#nn['date'] = pd.to_datetime(nn[['YEAR', 'MONTH', 'DAY']])

#F_scale categorization, ultimately I found that just stripping the letter before the original 
#f-scale entries was easier, these lines of categorization below resulted in negative numbers which 
#I had a feeling would make further analysis difficult. 
#nn['TOR_F_SCALE'] = nn['TOR_F_SCALE'].astype('category')
#nn['TOR_F_SCALE'] = nn['TOR_F_SCALE'].cat.codes
#nn = nn.set_index('date')

nn['TOR_F_SCALE'] = nn['TOR_F_SCALE'].astype(str)
nn['TOR_F_SCALE'] = nn['TOR_F_SCALE'].str.extract('(\d+)', expand = False)
nn['TOR_F_SCALE'] = nn['TOR_F_SCALE'].fillna(0)
nn['TOR_F_SCALE'] = nn['TOR_F_SCALE'].astype(int)


#categorize states into numbers
nn['STATE'] = nn['STATE'].astype('category')
nn['STATEcat'] = nn['STATE'].cat.codes
nn['STATEcat']

#slim down columns to state, tor_f_scale, total_damage, total_deaths, date
nn.info()
cols = [9, 14, 21, 22, 23, 24]
nn = nn.iloc[:,cols]



nn2 = nn
nn2.info()

##########################################################################################################################
##########################################################################################################################
##########################################################################################################################
#Individualize states
#create dictionary of individual state dataframes
list_of_df = []
unique_states = set(list(nn2['STATE']))
for state in unique_states:
  list_of_df.append(nn2.loc[nn2['STATE'] == state,:])

# this is the first dataframe of the list.
list_of_df[0]


states = nn2.STATE.unique()
statesdict = {elem : pd.DataFrame() for elem in states}
for key in statesdict.keys():
    statesdict[key] = nn2[:][nn2.STATE == key]
    
#Alabama
alabama = statesdict['ALABAMA']
cols = [8,11,12,13,14]
alabama = alabama.iloc[:,cols]
alabama = alabama.set_index('date')
alabama = alabama.groupby(pd.Grouper(freq = 'Y')).agg({'TOR_F_SCALE':'mean', 'TOTAL_DAMAGE':'sum', 
                                                       'TOTAL_DEATHS':'sum', 'TOTAL_INJURIES':'sum'})
alabama.columns = ['mean scale', 'sum damage', 'sum deaths', 'sum injuries']
alabama = alabama.fillna(0)  
##########################################################################################################################
##########################################################################################################################
##########################################################################################################################
#LTSM Model 

nn2=nn
#change index
nn2 = nn2.set_index('date')
#drop states column
nn2 = nn2.drop(columns = ['STATE'], axis = 1)
nn2.info()
#slim data to yearly info, takes mean of tor_f_scale and sums the rest
nn2 = nn2.groupby([(nn2.index.year), (nn2.index.month)]).agg({'TOR_F_SCALE':'mean', 'TOTAL_DAMAGE':'sum', 'TOTAL_DEATHS':'sum', 'TOTAL_INJURIES':'sum'})


import numpy
import matplotlib.pyplot as plt
from pandas import read_csv
import math
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import LSTM
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error


# convert an array of values into a dataset matrix
def create_dataset(dataset, look_back=1):
	dataX, dataY = [], []
	for i in range(len(dataset)-look_back-1):
		a = dataset[i:(i+look_back), 0]
		dataX.append(a)
		dataY.append(dataset[i + look_back, 0])
	return numpy.array(dataX), numpy.array(dataY)


# fix random seed for reproducibility
numpy.random.seed(7)


# load the dataset
#dataframe = nn2.drop(['TOTAL_DAMAGE', 'TOTAL_DEATHS', 'TOTAL_INJURIES'], axis = 1) #tor_f_scale model
dataframe = nn2.drop(['TOR_F_SCALE', 'TOTAL_DEATHS', 'TOTAL_INJURIES'], axis = 1) #total damage model
#dataframe = nn2.drop(['TOTAL_DAMAGE', 'TOR_F_SCALE', 'TOTAL_INJURIES'], axis = 1) #total deaths model
#dataframe = nn2.drop(['TOTAL_DAMAGE', 'TOTAL_DEATHS', 'TOR_F_SCALE'], axis = 1) #total injuries model

dataset = dataframe.values
dataset = dataset.astype('float32')

# normalize the dataset
scaler = MinMaxScaler(feature_range=(0, 1))
dataset = scaler.fit_transform(dataset)


# split into train and test sets
train_size = int(len(dataset) * 0.9)
test_size = len(dataset) - train_size
train, test = dataset[0:train_size,:], dataset[train_size:len(dataset),:]


# reshape into X=t and Y=t+1
look_back = 1
trainX, trainY = create_dataset(train, look_back)
testX, testY = create_dataset(test, look_back)


# reshape input to be [samples, time steps, features]
trainX = numpy.reshape(trainX, (trainX.shape[0], trainX.shape[1], 1))
testX = numpy.reshape(testX, (testX.shape[0], testX.shape[1], 1))


# create and fit the LSTM network
batch_size = 1
model = Sequential()
model.add(LSTM(4, batch_input_shape=(batch_size, look_back, 1), 
               stateful=True))
model.add(Dense(1))
model.compile(loss='mean_squared_error', optimizer='adam')
for i in range(100):
	model.fit(trainX, trainY, epochs=1, batch_size=batch_size, 
           verbose=2, shuffle=False)
	model.reset_states()
    
    
# make predictions
trainPredict = model.predict(trainX, batch_size=batch_size)
model.reset_states()
testPredict = model.predict(testX, batch_size=batch_size)


# invert predictions
trainPredict = scaler.inverse_transform(trainPredict)
trainY = scaler.inverse_transform([trainY])
testPredict = scaler.inverse_transform(testPredict)
testY = scaler.inverse_transform([testY])


# calculate root mean squared error
trainScore = math.sqrt(mean_squared_error(trainY[0], trainPredict[:,0]))
print('Train Score: %.2f RMSE' % (trainScore))

testScore = math.sqrt(mean_squared_error(testY[0], testPredict[:,0]))
print('Test Score: %.2f RMSE' % (testScore))

# shift train predictions for plotting
trainPredictPlot = numpy.empty_like(dataset)
trainPredictPlot[:, :] = numpy.nan
trainPredictPlot[look_back:len(trainPredict)+look_back, :] = trainPredict


# shift test predictions for plotting
testPredictPlot = numpy.empty_like(dataset)
testPredictPlot[:, :] = numpy.nan
testPredictPlot[len(trainPredict)+(look_back*2)+1:len(dataset)-1, :] = testPredict

# plot baseline and predictions
plt.plot(scaler.inverse_transform(dataset))
plt.plot(trainPredictPlot)
plt.plot(testPredictPlot)
plt.show()