note
	description: "Audio wave buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-03 8:18:07 GMT (Monday 3rd July 2023)"
	revision: "8"

class
	EL_AUDIO_WAVE_BUFFER

inherit
	EL_ALLOCATED_C_OBJECT
		rename
			c_size_of as c_size_of_WAVEHDR,
			integer_16_bytes as sample_bytes
		redefine
			dispose
		end

	EL_MULTIMEDIA_SYSTEM_C_API undefine copy, is_equal end

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make (a_device_handle: MANAGED_POINTER; some_audio_data: MANAGED_POINTER; block_size, a_samples_per_sec: INTEGER)
			--
		local
			status: INTEGER
		do
			make_default
			device_handle := a_device_handle
			audio_data := some_audio_data
			sample_block_size := block_size
			samples_per_sec := a_samples_per_sec
			c_set_data (self_ptr, audio_data.item)
			c_set_buffer_length (self_ptr, audio_data.count)
			status := c_wave_out_prepare_header (device_handle.item, self_ptr)
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
			status := c_wave_out_write (device_handle.item, self_ptr)
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
			status := c_wave_out_unprepare_header (device_handle.item, self_ptr)
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
			Result := c_dw_flags (self_ptr).bit_and (cdef_WHDR_PREPARED) /= 0
		end

	is_done: BOOLEAN
			--
		do
			Result := c_dw_flags (self_ptr).bit_and (cdef_WHDR_DONE) /= 0
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