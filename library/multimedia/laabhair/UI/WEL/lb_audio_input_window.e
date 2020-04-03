note
	description: "Lb audio input window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

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