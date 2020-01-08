note
	description: "[
		For Windows only. A 'do nothing app' for maintenance of class [$source EL_AUDIO_PLAYER_THREAD].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-06 20:14:56 GMT (Monday 6th January 2020)"
	revision: "5"

class
	MEDIA_PLAYER_DUMMY_APP

inherit
	TEST_SUB_APPLICATION
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

-- Commented out on Unix
-- player_thread: EL_AUDIO_PLAYER_THREAD [EL_16_BIT_AUDIO_PCM_SAMPLE]

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := << >>
		end

	test_run
		do
		end

feature {NONE} -- Constants

	Option_name: STRING = "dummy"

	Description: STRING = "Dummy application"

end
