note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_AUDIO_INPUT_CONTROLLER

inherit
	EL_MM_SYSTEM_CONSTANTS
		export
			{NONE} all
		undefine
			io
		end

	EL_MODULE_LOG

feature {NONE} -- Initialization

	make (a_waveform_format: EL_WAVEFORM_FORMAT; a_clip_duration_millisecs: INTEGER )
			--
		do
			create audio_clip_queue.make

			audio_clip_queue.attach_consumer (audio_clip_consumer)

			clip_duration_millisecs := a_clip_duration_millisecs

			waveform_format := a_waveform_format
			create audio_input_device.make (waveform_format, clip_duration_millisecs)
		end

feature {NONE} -- Basic operations

	start_recording
			--
		require
			not_recording: not is_recording
		do
			if clip_duration_millisecs_updated then
				create audio_input_device.make (waveform_format, clip_duration_millisecs)
				clip_duration_millisecs_updated := false
			end
			audio_input_device.set_win_handle (hwindow)
			if audio_input_device.open = MM_sys_err_noerror then
				if audio_input_device.start = MM_sys_err_noerror then
				else
					log.put_line ("Unable to start input device")
				end
			else
				log.put_line ("Unable to open wave input device")
			end
		end

	stop_recording
			--
		do
			if audio_input_device.reset = MM_sys_err_noerror then
				if audio_input_device.close = MM_sys_err_noerror then
				else
					log.put_line ("Unable to close input device")
				end
			else
				log.put_line ("Unable to reset input device")
			end
		end

feature -- Access

	is_recording: BOOLEAN

	clip_duration_millisecs: INTEGER

feature {NONE} -- Event handlers

	on_wim_open
			--
		do
			if audio_input_device.prepare_headers = MM_sys_err_noerror then
				if audio_input_device.add_buffers = MM_sys_err_noerror then
					is_recording := true
				else
					log.put_line ("Unable to add buffers to input device")
				end
			else
				log.put_line ("Unable to prepare input device headers")
			end
		end

	on_wim_data (audio_buffer: POINTER)
			-- Copy current audio buffer into queue for processing by consumer thread
		local
			audio_clip: EL_WAVE_AUDIO_16_BIT_CLIP
		do
			create audio_clip.make_from_c (waveform_format, audio_buffer)

			if audio_clip.buffer_length > 0 then
				audio_clip_queue.put (audio_clip)
			end
			if audio_input_device.is_win_handle_valid then
				if audio_input_device.requeue_buffer (audio_buffer) /= MM_sys_err_noerror then
					log.put_line ("Unable to requeue buffer to input device")
				end
			end
		end

	on_wim_close
			--
		do
			is_recording := false
		end

feature -- 	Element change

	set_clip_duration_millisecs (a_clip_duration_millisecs: INTEGER)
			--
		do
			clip_duration_millisecs := a_clip_duration_millisecs
			clip_duration_millisecs_updated := true
		end

feature {NONE} -- Implementation

	clip_duration_millisecs_updated: BOOLEAN

	audio_clip_queue: EL_THREAD_PRODUCT_QUEUE [EL_WAVE_AUDIO_16_BIT_CLIP]

	audio_clip_consumer: EL_CONSUMER_THREAD [EL_WAVE_AUDIO_16_BIT_CLIP]
			-- Separate thread for processing audio clips
		deferred
		end

	default_process_message (msg: INTEGER; wparam, lparam: POINTER)
			-- Handles window multi-media notification messages
		do
			if msg = MM_wim_data then
				on_wim_data (lparam)

			elseif msg = MM_wim_open then
				on_wim_open

			elseif msg = MM_wim_close then
				on_wim_close

			end
		end

	hwindow: POINTER
			-- Becomes {WEL_WINDOW}.item when inherited by a WEL_WINDOW.
			-- Rename as item in derived class
		deferred
		end

	audio_input_device: EL_AUDIO_INPUT_DEVICE

	waveform_format: EL_WAVEFORM_FORMAT

invariant

	valid_audio_input_device: audio_input_device /= Void

end





