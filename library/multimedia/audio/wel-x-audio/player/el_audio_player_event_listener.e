note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

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