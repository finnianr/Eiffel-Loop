note
	description: "Lb audio input window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

deferred class
	LB_AUDIO_INPUT_WINDOW

feature -- Basic operations

	start_recording
			-- User pressed start button
		deferred
		end

	stop_recording
			-- User pressed stop button
		deferred
		end

	destroy
			-- User pressed close button
		deferred
		end

end