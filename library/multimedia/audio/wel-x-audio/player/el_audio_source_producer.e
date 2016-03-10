note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_AUDIO_SOURCE_PRODUCER [SAMPLE_TYPE -> EL_AUDIO_PCM_SAMPLE create make end]

inherit
	EL_INTERRUPTABLE_THREAD
		rename
			make as make_thread
		end

	EL_MODULE_LOG

	EL_AUDIO_PLAYER_CONSTANTS

	EL_THREAD_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_thread
			create buffer_list.make (
				create {LINKED_LIST [EL_AUDIO_WAVE_BUFFER]}.make
			)
			create source.make (Void)
			create timer.make
		end

feature -- Basic operations

	queue_next_buffer
			-- Queue next buffer if available
		local
			l_source: EL_AUDIO_SAMPLE_SOURCE [SAMPLE_TYPE]
		do
			log.enter ("queue_next_buffer")
			source.lock
--			synchronized
				l_source := source.item
				if not l_source.after then
					l_source.forth
					buffer_list.lock
--					synchronized
						buffer_list.item.extend (l_source.data_item)
						if l_source.after then
							buffer_list.item.extend (Last_buffer_marker)
						end
--					end
					buffer_list.unlock
				end
--			end
			source.unlock
			log.exit
		end

	buffer_audio_from_source (event_listener: EL_AUDIO_PLAYER_EVENT_LISTENER; player_waiting_thread: EL_SUSPENDABLE_THREAD)
			--
		local
			l_source: EL_AUDIO_SAMPLE_SOURCE [SAMPLE_TYPE]
			sample_count, minimum_sample_count: INTEGER
		do
			log.enter ("buffer_audio_from_source")
			if source_under_production_rate > 0 then
				source.lock
--				synchronized
					l_source := source.item
					minimum_sample_count := (Duration_to_buffer_for * source_under_production_rate).rounded
					event_listener.on_buffering_start
					buffer_list.lock
--					synchronized
						from until is_interrupted or l_source.after or sample_count > minimum_sample_count loop
							buffer_list.item.extend (l_source.data_item)
							sample_count := sample_count + l_source.data_item_sample_count
							if l_source.index \\ 5 = 1 then
								event_listener.on_buffering_step ((sample_count / minimum_sample_count).truncated_to_real)
							end
							if sample_count < minimum_sample_count then
								l_source.forth
							end
						end
--					end
					buffer_list.unlock
					event_listener.on_buffering_end
--				end
				source.unlock
			end
			player_waiting_thread.resume
			previous_call_is_thread_signal
-- THREAD SIGNAL

			log.put_integer_field ("sample_count", sample_count)
			log.put_new_line
			log.exit
		end

	initialize (relative_start_position: REAL)
			--
		local
			l_source: EL_AUDIO_SAMPLE_SOURCE [SAMPLE_TYPE]
			source_production_rate, minimum_sample_count, sample_count: INTEGER
			is_minimum_data_buffered: BOOLEAN
		do
			log.enter_with_args ("initialize", << relative_start_position >>)
			set_uninterrupted
			source.lock
--			synchronized
				l_source := source.item
				minimum_sample_count := (Minimum_buffer_duration * l_source.header.samples_per_sec).rounded

				timer.start
				buffer_list.lock
				buffer_list.item.wipe_out
--				synchronized
					from
						l_source.go_relative_position (relative_start_position)
					until
						is_interrupted or l_source.after or is_minimum_data_buffered
					loop
						buffer_list.item.extend (l_source.data_item)
						sample_count := sample_count + l_source.data_item_sample_count

						if buffer_list.item.count >= Minimum_buffer_count and sample_count > minimum_sample_count then
							is_minimum_data_buffered := true
						else
							l_source.forth
						end
					end
--				end
				buffer_list.unlock
				timer.stop
				source_production_rate := (sample_count / timer.elapsed_time.fine_seconds_count).rounded
				source_under_production_rate := l_source.header.samples_per_sec - source_production_rate
--			end
			source.unlock
			log.put_integer_field ("source_under_production_rate", source_under_production_rate)
			log.put_new_line
			log.exit
		end

feature -- Element change

	set_source (a_source: EL_AUDIO_SAMPLE_SOURCE [SAMPLE_TYPE])
			--
		do
			source.lock
--			synchronized
				source.set_item (a_source)
--			end
			source.unlock
		end

feature {EL_AUDIO_SOURCE_PRODUCER_I} -- Access

	buffer_list: EL_SYNCHRONIZED_REF [LINKED_LIST [MANAGED_POINTER]]

feature {NONE} -- Implementation

	source: EL_SYNCHRONIZED_REF [EL_AUDIO_SAMPLE_SOURCE [SAMPLE_TYPE]]

	source_under_production_rate: INTEGER
			-- Rate at which production lags behind play rate in samples per sec
			-- (Difference between play rate and production rate)

	timer: EL_EXECUTION_TIMER

end
