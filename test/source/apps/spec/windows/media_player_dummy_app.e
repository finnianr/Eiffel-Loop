note
	description: "[
		For Windows only. A 'do nothing app' for maintenance of class EL_AUDIO_PLAYER_THREAD.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-19 21:55:22 GMT (Wednesday 19th December 2012)"
	revision: "1"

class
	MEDIA_PLAYER_DUMMY_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
		end

feature -- Basic operations

	run
			--
		do
		end

feature {NONE} -- Implementation

--	player_thread: EL_AUDIO_PLAYER_THREAD [EL_16_BIT_AUDIO_PCM_SAMPLE]

feature {NONE} -- Constants

	Option_name: STRING = "dummy"

	Description: STRING = "Dummy application"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
			>>
		end

end
