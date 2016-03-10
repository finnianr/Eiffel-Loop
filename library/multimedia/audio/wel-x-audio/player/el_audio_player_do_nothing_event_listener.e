note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_AUDIO_PLAYER_DO_NOTHING_EVENT_LISTENER

inherit
	EL_AUDIO_PLAYER_EVENT_LISTENER

create
	default_create

feature -- Event handlers

	on_buffer_played (progress_proportion: REAL)
			--
		do
		end

	on_finished
			--
		do
		end

	on_buffering_start
			--
		do
		end

	on_buffering_step  (progress_proportion: REAL)
			--
		do
		end

	on_buffering_end
			--
		do
		end

end
