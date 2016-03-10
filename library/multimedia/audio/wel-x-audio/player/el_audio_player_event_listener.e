note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_AUDIO_PLAYER_EVENT_LISTENER

feature -- Event handlers

	on_buffer_played (progress_proportion: REAL)
			--
		deferred
		end

	on_finished
			--
		deferred
		end

	on_buffering_start
			--
		deferred
		end

	on_buffering_step (progress_proportion: REAL)
			--
		deferred
		end

	on_buffering_end
			--
		deferred
		end

end
