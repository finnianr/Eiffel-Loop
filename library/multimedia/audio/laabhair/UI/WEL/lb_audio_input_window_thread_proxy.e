note
	description: "[
		Proxy object to (asynchronously) call procedures of `LB_AUDIO_INPUT_WINDOW' from 
		an external thread (non GUI thread)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 14:57:48 GMT (Thursday 7th July 2016)"
	revision: "4"

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