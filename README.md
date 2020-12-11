# _In vivo_ electrophysiology data analysis [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
It was firstly written in *Matlab* and later in *Python*. GUIs are provided for both version.
## Data Format
Multi-channel _in vivo_ extracellular electrophysiology data is acquired via National-Instrument DAQ card to computer.\
Data acquisition electrical circuit programmed in Labview is required.\
Sample data is provided. See Folder `Sample data`.\
Raw data is in _*.lvb_ format. Binary data is read trial by trial controled by Labview loop logic circuit.\
Within each trial, the data is concatenate Channle-by-Channel. Thus, data is formated as:  
>  Ch1Trial1  Ch2Trial1 ... ChNTrial1 Ch1Trial2 Ch2Trial2 ... ChNTrial2 ...  
> (N: number of channels)
## Processing pipeline
![Image](images/data_processing_flow.png "data_processing_flow")

## Data reading interface
For m files:\
start with `data_process.m` (with GUI)\
Click `data preview`, we will get `Data Preview` GUI.\
![Image](images/data_process_gui.png "data_process_gui")
## Data Preview interface
