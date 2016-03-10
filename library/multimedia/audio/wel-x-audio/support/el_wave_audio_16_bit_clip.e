note
	description: "Stores smaller amounts of waveaudio data in memory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_WAVE_AUDIO_16_BIT_CLIP

inherit
	MANAGED_POINTER
		rename
			make as make_pointer
		export
			{NONE} all
			{ANY} item
		end

	EL_AUDIO_SAMPLE_MEMORY_LIST
		rename
			normalized_item as normalized_sample_value,
			data_size as bytes_recorded
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

	sample_bytes: INTEGER
			--
		once
			Result := format.bits_per_sample // 8
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

	normalized_sample_value: REAL
			--
		local
			sample: INTEGER_16
		do
			sample := sample_ptr.read_integer_16 ((index - 1) * integer_16_bytes)
			Result := (sample / (sample.Max_value + 1)).truncated_to_real
		end

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

