note
	description: "[
		For Windows only. A 'do nothing app' for maintenance of class [$source EL_AUDIO_PLAYER_THREAD].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-20 17:51:59 GMT (Thursday 20th February 2020)"
	revision: "7"

class
	MEDIA_PLAYER_DUMMY_APP

inherit
	TEST_SUB_APPLICATION
		rename
			extra_log_filter as no_log_filter
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

-- Commented out on Unix
-- player_thread: EL_AUDIO_PLAYER_THREAD [EL_16_BIT_AUDIO_PCM_SAMPLE]

	test_run
		do
		end

feature {NONE} -- Constants

	Option_name: STRING = "dummy"

	Description: STRING = "Dummy application"

end
