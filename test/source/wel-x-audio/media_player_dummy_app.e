note
	description: "[
		For Windows only. A 'do nothing app' for maintenance of class ${EL_AUDIO_PLAYER_THREAD}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "9"

class
	MEDIA_PLAYER_DUMMY_APP

inherit
	EL_APPLICATION

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

	player_thread: EL_AUDIO_PLAYER_THREAD [EL_16_BIT_AUDIO_PCM_SAMPLE]

feature {NONE} -- Constants

	Description: STRING = "A 'do nothing app' for maintenance of class EL_AUDIO_PLAYER_THREAD"

end