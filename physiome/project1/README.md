
The only script that needs to be run is coding_script.m. However, coding_script.m depends on the 
- physiotoolkit folder
- estimateComparisons (off loads some q3 and q4 scripting for clarity)
- Subject.m (class methods for subjects | houses all functions)

This file can detect any s00000 folder as long as that folder is a n-child directory of the directory that this script is stored in. 
To run the script, make sure those three files are within the same directory as the subjects.

An example is provided below

--- Project/
      |
      |___ physiotoolkit/
      |
      |___ estimateComparisons.m
      |___ Subject.m
      |___ coding_script.m
      |
      |___ s00020/ 
      |
      |___ s00151/
      |
      |___ s00214/