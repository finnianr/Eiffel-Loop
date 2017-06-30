note
	description: "[
		For Windows only. A 'do nothing app' for maintenance of class `EL_AUDIO_PLAYER_THREAD'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 12:27:58 GMT (Thursday 29th June 2017)"
	revision: "3"

class
	MEDIA_PLAYER_DUMMY_APP

inherit
	REGRESSION_TESTABLE_SUB_APPLICATION
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

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := << >>
		end

end
