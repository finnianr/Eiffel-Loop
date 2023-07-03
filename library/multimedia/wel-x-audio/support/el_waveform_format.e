note
	description: "Waveform format"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-03 8:03:11 GMT (Monday 3rd July 2023)"
	revision: "7"

class
	EL_WAVEFORM_FORMAT

inherit
	EL_ALLOCATED_C_OBJECT
		rename
			c_size_of as c_size_of_wave_formatex
		end

	EL_WAVEFORM_FORMAT_ABS undefine copy, is_equal end

	EL_MULTIMEDIA_SYSTEM_C_API undefine copy, is_equal end

create
	make, make_default, make_16_bit_mono_PCM

feature {NONE} -- Initialization

	make (header: EL_AUDIO_WAVE_HEADER)
		do
			make_default
			set_samples_per_sec (header.samples_per_sec)
			set_bits_per_sample (header.bits_per_sample)
			set_format (header.format)
			set_num_channels (header.num_channels)
			set_block_align
			set_average_bytes_per_sec
			set_extra_format_info_size (0)
		end

	make_16_bit_mono_PCM (samples_per_sec_count: INTEGER)
			--
		do
			make_pcm
			set_num_channels (1)
			set_bits_per_sample (16)
			set_samples_per_sec (samples_per_sec_count)

			set_block_align
			set_average_bytes_per_sec
		ensure
			average_bytes_per_sec_valid: average_bytes_per_sec = samples_per_sec * block_align
			block_align_valid: block_align = num_channels * bits_per_sample // 8
		end

	make_pcm
			--
		do
			make_default
			set_format (PCM_format)
			set_extra_format_info_size (0)
		end

feature -- Access

	buffer_size_for_duration (milliseconds: INTEGER): INTEGER
			-- Buffer size required for duration of milliseconds
		local
			samples_in_duration_count: INTEGER
		do
			samples_in_duration_count := (milliseconds.to_real * samples_per_sec.to_real / 1000.0).rounded
			Result := samples_in_duration_count * block_align
		end

	format: INTEGER_16
			--
		do
			Result := c_format (self_ptr).to_integer_16
		end

	num_channels : INTEGER
			--
		do
			Result := c_num_channels (self_ptr)
		end

	samples_per_sec: INTEGER
			--
		do
			Result := c_samples_per_sec (self_ptr)
		end

	bits_per_sample: INTEGER
			--
		do
			Result := c_bits_per_sample (self_ptr)
		end

	average_bytes_per_sec: INTEGER
			--
		do
			Result := c_average_bytes_per_sec (self_ptr)
		end

	block_align: INTEGER
			--
		do
			Result := c_block_align (self_ptr)
		end

feature -- Element change

	set_format (a_format: INTEGER)
			--
		require
			valid_format: is_valid_format (a_format)
		do
			c_set_format (self_ptr, a_format)
		end

	set_num_channels (number: INTEGER)
			--
		do
			c_set_num_channels (self_ptr, number)
		end

	set_samples_per_sec (samples_per_sec_count: INTEGER)
			--
		do
			c_set_samples_per_sec (self_ptr, samples_per_sec_count)
		end

	set_bits_per_sample (bits: INTEGER)
			--
		do
			c_set_bits_per_sample (self_ptr, bits)
		end

	set_extra_format_info_size (size_byte_count: INTEGER)
			--
		do
			c_set_cb_size (self_ptr, size_byte_count)
		end

	set_block_align
			--
		do
			c_set_block_align (self_ptr, num_channels * bits_per_sample // 8)
		end

	set_average_bytes_per_sec
			--
		do
			c_set_average_bytes_per_sec (self_ptr, samples_per_sec * block_align)
		end

invariant
	valid_average_bytes_per_sec: c_average_bytes_per_sec (self_ptr) = c_samples_per_sec (self_ptr) * c_block_align (self_ptr)

	valid_block_align: c_block_align (self_ptr) = c_num_channels (self_ptr) * c_bits_per_sample (self_ptr) // 8

end