note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_MATLAB_16_BIT_AUDIO_SEGMENT_LIST

inherit
	ARRAYED_LIST [EL_16_BIT_AUDIO_SAMPLE_ARRAYED_LIST]
		rename
			item as segment
		end
		
	EL_LOGGING
		undefine
			is_equal, copy
		end

create	 
	make
	
feature -- Conversion

	to_matlab_double_array: EL_MATLAB_DOUBLE_ROW_VECTOR
			-- 
		local
			i, sample_count: INTEGER
		do
			from start until after loop
				sample_count := sample_count + segment.sample_count
				forth
			end
			create Result.make (sample_count)
			from 
				start 
				i := 1
			until 
				after 
			loop
				from 
					segment.start
				until
					segment.after
				loop
					Result.put (segment.item / Max_16_bit_plus_1, i)
					segment.forth
					i := i + 1
				end
				forth
			end
			check
				all_samples_assigned: sample_count = i - 1
			end
		end

feature {NONE} -- Constants

	Max_16_bit_plus_1: INTEGER = 32768
		
end

