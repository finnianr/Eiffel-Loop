note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

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
