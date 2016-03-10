note
	description: "[
		For Windows only. A 'do nothing app' for maintenance of class EL_AUDIO_PLAYER_THREAD.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 14:52:46 GMT (Thursday 1st January 2015)"
	revision: "4"

class
	MEDIA_PLAYER_DUMMY_APP

inherit
	TEST_APPLICATION
		redefine
			Option_name
		end

create
	make

feature -- Basic operations

	test_run
			--
		do
		end

feature {NONE} -- Implementation

-- Commented out on Unix
-- player_thread: EL_AUDIO_PLAYER_THREAD [EL_16_BIT_AUDIO_PCM_SAMPLE]

feature {NONE} -- Constants

	Option_name: STRING = "dummy"

	Description: STRING = "Dummy application"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := << >>
		end

end
