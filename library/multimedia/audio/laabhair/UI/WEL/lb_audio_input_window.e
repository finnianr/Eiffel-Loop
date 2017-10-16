note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

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