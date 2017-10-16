note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_AUDIO_PLAYER_CONSTANTS

feature -- Constants

	Minimum_buffer_duration: REAL
			--
		once
			Result := 0.35
		end

	Duration_to_buffer_for: REAL
			-- Minimum continuous play duration to buffer for
		once
			Result := 2 * 60
		end

	Last_buffer_marker: MANAGED_POINTER
			--
		once ("PROCESS")
			create Result.make (0)
		end

	Minimum_buffer_count: INTEGER
			--
		once
			Result :=  4
		end

	Minimum_time_between_buffer_played_events: REAL
			-- Minimum time in secs between buffer played events
		once
			Result :=  0.3
		end

end