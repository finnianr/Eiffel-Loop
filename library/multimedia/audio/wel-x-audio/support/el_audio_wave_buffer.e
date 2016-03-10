note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_AUDIO_WAVE_BUFFER

inherit
	MANAGED_POINTER
		rename
			make as make_pointer,
			integer_16_bytes as sample_bytes,
			item as current_item
		export
			{NONE} all
		redefine
			dispose
		end

	EL_WINDOWS_AUDIO_API
		undefine
			copy, is_equal
		end

	EL_MM_SYSTEM_CONSTANTS
		undefine
			copy, is_equal
		end

	EL_MODULE_LOG
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_device_handle: MANAGED_POINTER; some_audio_data: MANAGED_POINTER; block_size, a_samples_per_sec: INTEGER)
			--
		local
			status: INTEGER
		do
			make_pointer (c_size_of_WAVEHDR)
			device_handle := a_device_handle
			audio_data := some_audio_data
			sample_block_size := block_size
			samples_per_sec := a_samples_per_sec
			c_set_data (current_item, audio_data.item)
			c_set_buffer_length (current_item, audio_data.count)
			status := c_wave_out_prepare_header (device_handle.item, current_item)
			check
				no_error_preparing_header: status = cdef_MMSYSERR_NOERROR
			end
		end

feature -- Access

	sample_count: INTEGER
			--
		do
			Result := audio_data.count // sample_block_size
		end

	sample_block_size: INTEGER

	samples_per_sec: INTEGER

	duration: REAL
			-- duration ins secs
		do
			Result := (sample_count / samples_per_sec).truncated_to_real
		end

feature -- Basic operations

	queue_to_play
			--
		require
			is_prepared: is_prepared
		local
			status: INTEGER
		do
			log.enter ("queue_to_play")
			status := c_wave_out_write (device_handle.item, current_item)
			check
				no_device_error_occured: status = cdef_MMSYSERR_NOERROR
			end
			log.exit
		end

	prepare_disposal
			--
		require
			header_is_prepared: is_prepared
			is_done: is_done
		local
			status: INTEGER
		do
			status := c_wave_out_unprepare_header (device_handle.item, current_item)
			is_prepared_for_disposal := status = cdef_MMSYSERR_NOERROR
		ensure
			prepared_for_disposal: is_prepared_for_disposal
		end

feature -- Element change

	set_last
			--
		do
			is_last := true
		end

feature -- Status query

	is_last: BOOLEAN

	is_prepared: BOOLEAN
			--
		do
			Result := c_dw_flags (current_item).bit_and (cdef_WHDR_PREPARED) /= 0
		end

	is_done: BOOLEAN
			--
		do
			Result := c_dw_flags (current_item).bit_and (cdef_WHDR_DONE) /= 0
		end

feature {NONE} -- Disposal

	dispose
			--
		require else
			is_prepared_for_disposal: is_prepared_for_disposal
		do
			Precursor
		end

feature {NONE} -- Implementation

	is_prepared_for_disposal: BOOLEAN

	audio_data: MANAGED_POINTER

	device_handle: MANAGED_POINTER

invariant
	audio_data_count_multiple_of_sample_block_size: audio_data.count \\ sample_block_size = 0

end
