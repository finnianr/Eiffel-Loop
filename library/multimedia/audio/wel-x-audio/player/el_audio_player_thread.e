note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_AUDIO_PLAYER_THREAD [SAMPLE_TYPE -> EL_AUDIO_PCM_SAMPLE create make end]

inherit
	EL_DORMANT_ACTION_LOOP_THREAD
		rename
			resume as play,
			suspend as stop_play,
			is_suspended as is_play_stopped,
			on_suspension as on_finished_play,
			on_resumption as on_start_play,
			do_action as cycle_play_buffers
		redefine
			on_exit, on_finished_play, on_start_play, stop_play, Is_visible_in_console
		end

	EL_AUDIO_PLAYER_CONSTANTS
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_LOG
		undefine
			default_create, is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			default_create
			create play_buffer.make
			create source_producer.make (
				create {EL_AUDIO_SOURCE_PRODUCER [SAMPLE_TYPE]}.make
			)
			set_event_listener (create {EL_AUDIO_PLAYER_DO_NOTHING_EVENT_LISTENER})
			create channel_volume_settings.make (<< 50, 50 >>)
		end

feature -- Access

	buffer_duration_secs: REAL

	play_duration: REAL

feature -- Element change

	set_source (a_source: EL_AUDIO_SAMPLE_SOURCE [SAMPLE_TYPE])
			--
		do
			source_header := a_source.header
			set_samples_played_maximum (source_header.sample_count)
			source_producer.set_source (a_source)
		end

	set_event_listener (an_event_listener: like event_listener)
			-- Set `event_listener' to `an_event_listener'.
		do
			event_listener := an_event_listener
		ensure
			event_listener_assigned: event_listener = an_event_listener
		end

	set_samples_played_maximum (a_samples_played_maximum: like samples_played_maximum)
			-- Set `samples_played_maximum' to `a_samples_played_maximum'.
		do
			samples_played_maximum := a_samples_played_maximum
		ensure
			samples_played_maximum_assigned: samples_played_maximum = a_samples_played_maximum
		end

	set_play_duration (duration: REAL)
			--
		do
			play_duration := duration
			samples_played_maximum := (play_duration * source_header.samples_per_sec).rounded
		end

	set_relative_start_position (unit_relative_pos: REAL)
			--
		require
			is_unit: unit_relative_pos.sign >= 0 and unit_relative_pos <= 1.0
		do
			relative_start_position := unit_relative_pos
		end

feature -- Basic operations

	stop_play
			--
		do
			Precursor
			source_producer.stop
		end

	pause
			--
		do
			if audio_device.is_open and then not audio_device.is_paused then
				audio_device.pause
			end
		end

	resume_play
			--
		do
			if audio_device.is_open and then audio_device.is_paused then
				audio_device.restart
			end
		end

	set_channel_volume_settings (volume_settings: ARRAY [INTEGER])
			--
		do
			channel_volume_settings.lock
--			synchronized
				channel_volume_settings.set_item (volume_settings)
				if not is_play_stopped then
					audio_device.set_volume_as_percentage (channel_volume_settings.item)
				end
--			end
			channel_volume_settings.unlock
		end

feature -- Status query

	all_samples_played: BOOLEAN
			--
		do
			Result := samples_played_count >= samples_played_maximum
		end

	is_play_paused: BOOLEAN
			--
		do
			Result := audio_device.is_paused
		end

	is_last_buffer_played: BOOLEAN

feature {NONE} -- Implementation: routines

	on_exit
			--
		do
			log.enter ("on_exit")
			source_producer.exit
			log.exit
		end

	on_start_play
			--
		local
			volume_settings: ARRAY [INTEGER]
			ch: INTEGER
		do
			log.enter ("on_start_play")

			buffers_played_count := 0
			buffered_sample_count := 0
			samples_played_count := 0
			is_last_buffer_played := false
			last_event_time := 0

			channel_volume_settings.lock
--			synchronized
				if channel_volume_settings.item = Void
					or else channel_volume_settings.item.count /= source_header.num_channels
				then
					create volume_settings.make (1, source_header.num_channels)
					from ch := 1 until ch > volume_settings.count loop
						volume_settings.put (50, ch)
						ch := ch + 1
					end
					channel_volume_settings.set_item (volume_settings)
				end
				create audio_device.make_open (source_header)
				audio_device.save_volume_setting
				audio_device.set_volume_as_percentage (channel_volume_settings.item)
--			end
			channel_volume_settings.unlock

			source_producer.initialize (relative_start_position)
			log.put_integer_field ("samples_played_maximum", samples_played_maximum)
			log.put_new_line

			log.exit
		end

	on_finished_play
			--
		do
			audio_device.reset
			remove_played_buffers (false)
			audio_device.restore_volume_setting
			audio_device.close
			event_listener.on_finished
		end

	cycle_play_buffers
			--
		do
			log.enter ("cycle_play_buffers")
			if play_buffer.is_empty then
				log.put_line ("play_buffer.is_empty: true")
				source_producer.buffer_audio_from_source (event_listener, Current)

				suspend_thread  -- Suspended until source producing thread finishes
				Previous_call_is_blocking_thread
-- THREAD WAITING

			end

			if not is_play_stopped then
				fill_play_buffer
			end

			if not play_buffer.is_empty then
				wait_for_playing_buffer_to_finish
				remove_played_buffers (true)
			end

			if is_last_buffer_played or else samples_played_count >= samples_played_maximum then
				stop_play
			end

			log.put_integer_field ("buffered_sample_count", buffered_sample_count)
			log.put_new_line
			log.exit
		end

	wait_for_playing_buffer_to_finish
			--
		local
			wait_millisecs: INTEGER
			count: INTEGER
		do
			log.enter ("wait_for_playing_buffer_to_finish")
			from
				log.put_line ("Sleeping..")
				wait_millisecs := (play_buffer.item.duration * 1000).ceiling + 3
			until
				is_play_stopped or else audio_device.buffers_played_count > buffers_played_count
			loop
				sleep_millisecs (wait_millisecs)
				wait_millisecs := 4
				count := count + 1
			end
			log.put_integer_field ("sleep_count", count)
			log.put_new_line

			log.put_integer_field (
				"audio_device.buffers_played_count - buffers_played_count",
				audio_device.buffers_played_count - buffers_played_count
			)
			log.put_new_line
			buffers_played_count := audio_device.buffers_played_count
			log.exit
		end

	remove_played_buffers (add_more: BOOLEAN)
			--
		do
			log.enter ("remove_played_buffers")
			from until play_buffer.is_empty or else not play_buffer.item.is_done loop
				buffered_sample_count := buffered_sample_count - play_buffer.item.sample_count
				samples_played_count := samples_played_count + play_buffer.item.sample_count
				log.put_integer_field ("samples_played_count", samples_played_count)
				log.put_integer_field (" samples_played_maximum", samples_played_maximum)
				log.put_new_line
				play_buffer.item.prepare_disposal
				if play_buffer.item.is_last then
					is_last_buffer_played := true
				end
				play_buffer.remove
				if add_more then
					source_producer.queue_next_buffer
				end
			end
			send_buffer_played_event
			log.put_integer_field ("play_buffer.count", play_buffer.count)
			log.put_new_line
			log.exit
		end

	fill_play_buffer
			--
		local
			source_buffer: LINKED_LIST [MANAGED_POINTER]
			last_source_buffer: EL_AUDIO_WAVE_BUFFER
		do
			log.enter ("fill_play_buffer")
			create source_buffer.make
			source_producer.merge_buffer_list_into_other (source_buffer)
			from source_buffer.start until source_buffer.after loop
				if source_buffer.item = Last_buffer_marker then
					last_source_buffer.set_last
				else
					last_source_buffer := create_wave_buffer (source_buffer.item)
					play_buffer.extend (last_source_buffer)
					last_source_buffer.queue_to_play
					buffered_sample_count := buffered_sample_count + last_source_buffer.sample_count
				end
				source_buffer.forth
			end
			log.put_integer_field ("buffered_sample_count", buffered_sample_count)
			log.put_new_line
			log.exit
		end

	send_buffer_played_event
			--
		local
			elapsed_play_time: REAL
		do
			elapsed_play_time := (samples_played_count / source_header.samples_per_sec).truncated_to_real
			if elapsed_play_time - last_event_time >= Minimum_time_between_buffer_played_events then
				last_event_time := elapsed_play_time
				event_listener.on_buffer_played ((samples_played_count / samples_played_maximum).truncated_to_real.min (1.0))
			end
		end

	create_wave_buffer (audio_data: MANAGED_POINTER): EL_AUDIO_WAVE_BUFFER
			--
		do
			create Result.make (
				audio_device.device_handle, audio_data, source_header.block_align, source_header.samples_per_sec
			)
		end

feature {NONE} -- Implementation: components

	play_buffer: LINKED_QUEUE [EL_AUDIO_WAVE_BUFFER]

	audio_device: EL_AUDIO_OUTPUT_DEVICE

	event_listener: EL_AUDIO_PLAYER_EVENT_LISTENER

	source_producer: EL_AUDIO_SOURCE_PRODUCER_I [SAMPLE_TYPE]

feature {NONE} -- Implementation: variables

	channel_volume_settings: EL_SYNCHRONIZED_REF [ARRAY [INTEGER]]

	source_header: EL_AUDIO_WAVE_HEADER

	buffered_sample_count: INTEGER

	buffers_played_count: INTEGER

	samples_played_count: INTEGER

	samples_played_maximum: INTEGER

	relative_start_position: REAL

	last_event_time: REAL
		-- Time when last buffer played event generated measured as secs of play


feature {NONE} -- Constants

	Is_visible_in_console: BOOLEAN = true

end
