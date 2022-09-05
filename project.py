# -*- coding: utf-8 -*-
"""
Created on Tue Nov 30 19:24:47 2021

@author: forrest
"""

import warnings

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
from matplotlib import rcParams

rcParams["xtick.labelsize"] = 15
rcParams["ytick.labelsize"] = 15
rcParams["legend.fontsize"] = "small"

pd.set_option("precision", 2)
warnings.filterwarnings("ignore")

sp500 = pd.read_csv(r"C:\Users\forrest\Desktop\schoo\IST 652 - scripting\project\sp500.csv",parse_dates=["date"]).dropna()
tsla = pd.read_csv(r"C:\Users\forrest\Desktop\schoo\IST 652 - scripting\project\tesla.csv",parse_dates=["Date"])
tsla2 = pd.DataFrame(tsla['Date'], tsla['Close'])
spmatch = sp500[~(sp500['date'] < '2010-06-29')]
final = pd.DataFrame(tsla, spmatch)
tsla2.head()
