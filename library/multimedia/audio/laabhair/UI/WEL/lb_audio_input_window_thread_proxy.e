note
	description: "[
		Proxy object to (asynchronously) call procedures of `LB_AUDIO_INPUT_WINDOW' from 
		an external thread (non GUI thread)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "3"

class
	LB_AUDIO_INPUT_WINDOW_THREAD_PROXY

inherit
	EL_MAIN_THREAD_PROXY [LB_AUDIO_INPUT_WINDOW]
		rename
			target as audio_input_window
		export
			{NONE} all
		end
	
	LB_AUDIO_INPUT_WINDOW
		export
			{NONE} all
		end
	
create
	make

feature -- Basic operations

	start_recording
			-- User pressed start button
		do
			call (agent audio_input_window.start_recording)
		end

	stop_recording
			-- User pressed stop button
		do
			call (agent audio_input_window.stop_recording)
		end

	destroy
			-- 
		do
			call (agent audio_input_window.destroy)
		end

end