note
	description: "Stores smaller amounts of waveaudio data in memory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_WAVE_AUDIO_CLIP

inherit
	MANAGED_POINTER
		rename
			make as make_pointer,
			integer_16_bytes as sample_bytes
		export
			{NONE} all
			{EL_AUDIO_INPUT_DEVICE} item
		end

	EL_AUDIO_ANALYSIS_ROUTINES
		undefine
			is_equal, copy
		end

create
	make, make_from_c

feature {NONE} -- Initialization

	make (a_format: EL_WAVEFORM_FORMAT; duration: INTEGER)
			--

		do
			make_pointer (structure_size)
			format := a_format
			millisec_duration := duration

			create audio_data.make (format.buffer_size_for_duration (millisec_duration))

			-- Zeroize all structure members
			audio_data.item.memory_set (0, audio_data.count)

			c_set_data (item, audio_data.item)
			c_set_buffer_length (item, audio_data.count)
			c_set_loop_control_counter (item, 1)
		end

	make_from_c (a_format: EL_WAVEFORM_FORMAT; audio_buffer: POINTER)
			--
		do
			format := a_format
			make_from_pointer (audio_buffer, structure_size)
			create audio_data.make_from_pointer (data , buffer_length)
			c_set_data (item, audio_data.item)
		end

feature -- Basic operations

	save (fn: STRING)
			--
		local
			file_out: EL_WAVE_FILE
		do
			create file_out.make_open_write (fn, format.num_channels, format.bits_per_sample, format.samples_per_sec)
			file_out.header.set_sample_count (sample_count)
			file_out.close
		end


feature -- Access

	format: EL_WAVEFORM_FORMAT

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		once
			Result := c_size_of_WAVEHDR
		end

	sample_count: INTEGER
			--
		do
			Result := bytes_recorded // format.block_align
		end

	bytes_recorded: INTEGER
			--
		do
			Result := c_bytes_recorded (item)
		end

	buffer_length: INTEGER
			--
		do
			Result := c_buffer_length (item)
		end

	data: POINTER
			--
		do
			Result := c_data (item)
		end

feature {NONE} -- Implementation

	millisec_duration: INTEGER

	audio_data: MANAGED_POINTER

feature {NONE} -- C externals: Access

	c_size_of_WAVEHDR: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"sizeof (WAVEHDR)"
		end

	c_bytes_recorded (p: POINTER): INTEGER
			--
		external
			"C [struct <mmsystem.h>] (WAVEHDR): EIF_INTEGER"
		alias
			"dwBytesRecorded"
		end

	c_buffer_length (p: POINTER): INTEGER
			--
		external
			"C [struct <mmsystem.h>] (WAVEHDR): EIF_INTEGER"
		alias
			"dwBufferLength"
		end

	c_data (p: POINTER): POINTER
			--
		external
			"C [struct <mmsystem.h>] (WAVEHDR): EIF_INTEGER"
		alias
			"lpData"
		end

feature {NONE} -- C externals: setters

	c_set_data (p: POINTER; data_ptr: POINTER)
			--
		external
			"C [struct <mmsystem.h>] (WAVEHDR, LPSTR)"
		alias
			"lpData"
		end

	c_set_buffer_length (p: POINTER; length: INTEGER)
			--
		external
			"C [struct <mmsystem.h>] (WAVEHDR, DWORD)"
		alias
			"dwBufferLength"
		end

	c_set_loop_control_counter (p: POINTER; counter: INTEGER)
			--
		external
			"C [struct <mmsystem.h>] (WAVEHDR, DWORD)"
		alias
			"dwLoops"
		end

end

