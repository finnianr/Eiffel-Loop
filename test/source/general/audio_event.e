note
	description: "Illustrates REAL assignment bug"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:44 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	AUDIO_EVENT

create
	make

feature {NONE} -- Initialization
	
	make (an_onset_time, an_offset_time: REAL)
			-- 
		do
			onset_time := an_onset_time
			offset_time := an_offset_time
		end
		
feature -- 	Measurement

	onset_time: REAL
	
	offset_time: REAL
	
	duration: REAL
			-- 
		do
			Result := offset_time - onset_time
			
--			Workaround
--			Result := (Result * 1.0e5).floor * 1.0e-5
		end
		
	is_threshold_exceeded (duration_threshold: REAL): BOOLEAN
			-- 
		do

--			Work around 2
--			if duration.out.to_real > duration_threshold then

			if duration > duration_threshold then
				Result := true
			end	
		end

end
