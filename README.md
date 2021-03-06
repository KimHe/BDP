# BASH-based data post-processing (BDP)

* files: the file names of data that you are going to process
* strings: the *CAS No.* or *names* of elements of data that you want to extract from each data file

## GUIDELINE:

* For the TXT datasets:

0. In all TXT files, PLEASE delete the HEAD rows 
    (these would be redundant information for the program);
1. PLEASE put the element names at the END column
    (because element names have varying lengths);

* For the output datasets

0. All spaces were replaced with \s;
1. All square brackets [] were replaced with \[\];
2. The initial dots (.) in the element names were deleted;
3. All asterisks were replaced with dots (.);
4. All primes in the element names might be dangerous for the program

## Dependences
    lower versions might also work, but no guarantee

* >=ssconvert-1.12.39 (gnumeric)
* >=grep-3.1
* >=sed-8.30
* >=sort-8.30
* >=paste-8.30
* >=cat-8.30

## Compile

* make 
* make install
