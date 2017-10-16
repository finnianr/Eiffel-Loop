note
	description: "Illustrates REAL assignment bug"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:02 GMT (Thursday 12th October 2017)"
	revision: "2"

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