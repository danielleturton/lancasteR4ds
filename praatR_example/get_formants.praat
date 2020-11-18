## SK 2019-01-28
## Find all non-null intervals on tier 2 & get formants (midpoint) & get labels
## Also gets contextual info from interval 2 on tiers 3-6

form Enter the relevant info below:
	comment Enter the directory where the WAV/TextGrid files are located:
	sentence directory /users/sam/Desktop/test/01/
	comment Specify maximum formant
	natural max_formant 5500
	comment Specify number of formants
	natural n_formants 5
endform

header$ = "file,segment,F1,F2,F3,duration"
writeInfoLine: header$

Create Strings as file list...  list 'directory$'*.wav
number_files = Get number of strings

for j from 1 to number_files
     select Strings list
     current_token$ = Get string... 'j'
     Read from file... 'directory$''current_token$'
     file_name$ = selected$ ("Sound")
     To Formant (burg)... 0.0025 n_formants max_formant 0.025 50
     Read from file... 'directory$''file_name$'.TextGrid

     select TextGrid 'file_name$'
     number_of_intervals = Get number of intervals... 1
     for b from 1 to number_of_intervals
         select TextGrid 'file_name$'
          interval_label$ = Get label of interval... 1 'b'
          	if interval_label$ <> ""
				segment$ = Get label of interval... 1 'b'
				begin_vowel = Get starting point... 1 'b'
				end_vowel = Get end point... 1 'b'
				measure_dur = end_vowel - begin_vowel
				time_50 = begin_vowel + (0.50 * measure_dur)

				select Formant 'file_name$'
				f1 = Get value at time... 1 'time_50' Hertz Linear
				f2 = Get value at time... 2 'time_50' Hertz Linear
				f3 = Get value at time... 3 'time_50' Hertz Linear

				resultLine$ = "'file_name$','segment$','f1','f2','f3','measure_dur'"
				appendInfoLine: resultLine$
           endif
     endfor

	select all
	minus Strings list
	Remove

endfor

select all
Remove
clearinfo