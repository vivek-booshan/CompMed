# Q6
import pandas as pd
data_path = '/Users/jayluo/Downloads/MNI_286Labels_corrected_stats.txt'

patient_dat_df = pd.read_csv(data_path, sep = '\t', skiprows=9, header=None)

# drop last column (all nan's)
patient_dat_df = patient_dat_df.drop(columns=7)

# remove rows w/ nan
patient_dat_df = patient_dat_df.dropna()

patient_dat_df.columns = ['Image', 'Object', 'Volume_mm3', 'Min', 'Max', 'Mean', 'Std']

# filter for BIOCARD regions


""" Get z-scores relative to HEALTHY CONTROL population"""
# for each region subtract 'Volume_mme3' by population healthy control mean and divide by population s.d. for that region


