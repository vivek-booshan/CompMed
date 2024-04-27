The only script that needs to be run is coding_script.m. However, coding_script.m depends on the 
- physiotoolkit folder (acquired from Dr. Greenstein)
- estimateComparisons (off loads some q3 and q4 scripting for clarity)
- Subject.m (class methods for subjects | houses all functions)

This file can detect any s00000 folder as long as that folder is a n-child directory of the directory that this script is stored in. 
To run the script, make sure those three files are within the same directory as the subjects.

An example is provided below

.
├── archive
├── coding_script.asv
├── coding_script.m
├── estimateComparisons.m
├── images
├── PhysioToolkit
├── README.md
├── s00020
├── s00138
├── s00151
├── s00214
├── Subject.asv
└── Subject.m

7 directories, 6 files
