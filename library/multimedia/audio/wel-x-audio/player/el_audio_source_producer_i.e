note
	description: "[
		Object that asynchronously calls routines in the audio producer thread. The calls are queued until
		the producer thread gets around to them.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_AUDIO_SOURCE_PRODUCER_I [SAMPLE_TYPE -> EL_AUDIO_PCM_SAMPLE create make end]

inherit
	EL_THREAD_PROXY [EL_AUDIO_SOURCE_PRODUCER [SAMPLE_TYPE], TUPLE]
		rename
			stop as exit
		redefine
			call_consumer
		end

	EL_MODULE_LOG

create
	make

feature -- Basic operations

	queue_next_buffer
			--
		do
			log.enter ("queue_next_buffer")
			queue_call (agent target.queue_next_buffer)
			log.exit
		end

	buffer_audio_from_source (event_listener: EL_AUDIO_PLAYER_EVENT_LISTENER; waiting_player_thread: EL_SUSPENDABLE_THREAD)
			--
		do
			queue_call_with_args (agent target.buffer_audio_from_source, [event_listener, waiting_player_thread])
		end

	initialize (relative_start_position: REAL)
			--
		do
			target.initialize (relative_start_position)
		end

	stop
			--
		do
			target.interrupt
			call_queue.wipe_out
		end

feature -- Element change

	set_source (a_source: EL_AUDIO_SAMPLE_SOURCE [SAMPLE_TYPE])
			--
		do
			target.set_source (a_source)
		end

feature -- Access

	merge_buffer_list_into_other (other: LINKED_LIST [MANAGED_POINTER])
			--
		do
			target.buffer_list.lock
--			synchronized
				other.merge_right (target.buffer_list.item)
--			end
			target.buffer_list.unlock
		end

feature {NONE} -- Implementation

	call_consumer: EL_AUDIO_SOURCE_PRODUCER_THREAD [SAMPLE_TYPE]

end
