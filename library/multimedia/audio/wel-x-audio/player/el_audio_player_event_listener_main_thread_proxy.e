note
	description: "[
		Object that allows audio player to asynchronously call event handling routines in GUI thread.
		Essentially the calls are put into a queue and the GUI thread executes them whenever it gets a chance
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_AUDIO_PLAYER_EVENT_LISTENER_MAIN_THREAD_PROXY

inherit
	EL_MAIN_THREAD_PROXY [EL_AUDIO_PLAYER_EVENT_LISTENER]

	EL_AUDIO_PLAYER_EVENT_LISTENER

create
	make

feature -- Event handlers

	on_buffer_played (progress_proportion: REAL)
			--
		do
			call (agent target.on_buffer_played (progress_proportion))
		end

	on_finished
			--
		do
			call (agent target.on_finished)
		end

	on_buffering_start
			--
		do
			call (agent target.on_buffering_start)
		end

	on_buffering_step (progress_proportion: REAL)
			--
		do
			call (agent target.on_buffering_step  (progress_proportion))
		end

	on_buffering_end
			--
		do
			call (agent target.on_buffering_end)
		end

end
