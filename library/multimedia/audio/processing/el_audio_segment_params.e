note
	description: "Audio segment params"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:05 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_AUDIO_SEGMENT_PARAMS

inherit
	INTEGER_INTERVAL
		rename 
			upper as offset, 			-- millisecs
			lower as onset, 			-- millisecs
			
			count as segment_duration	-- millisecs
		end

create
	make_from_secs

feature -- Initialization

	make_from_secs (an_onset_secs, an_offset_secs, duration_secs: REAL)
			-- 
		do
			make ((an_onset_secs * 1000).rounded, (an_offset_secs * 1000).rounded)
			total_duration := (duration_secs * 1000).rounded
		end

feature -- Measurement

	relative_onset: REAL
			-- 
		do
			Result := (onset / total_duration).truncated_to_real
		end
	
	relative_offset: REAL
			-- 
		do
			Result := (offset / total_duration).truncated_to_real
		end
	
	onset_secs: REAL
			-- 
		do
			Result := (onset / 1000).truncated_to_real
		end
		
	offset_secs: REAL
			-- 
		do
			Result := (offset / 1000).truncated_to_real
		end
	
	total_duration: INTEGER
		-- Total audio duration in millisces

	duration: INTEGER
		-- Segment audio duration in millisces
		do
			Result := offset - onset
		end

end