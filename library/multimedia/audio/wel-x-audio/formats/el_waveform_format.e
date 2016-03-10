note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_WAVEFORM_FORMAT

inherit
	MANAGED_POINTER
		rename
			make as make_pointer
		export
			{NONE} all
			{ANY} item
		end

	EL_WAVEFORM_FORMAT_ABS
		undefine
			copy, is_equal
		end

	EL_WINDOWS_AUDIO_API
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_pointer (c_size_of_wave_formatex)
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
			Result := c_format (item).to_integer_16
		end

	num_channels : INTEGER
			--
		do
			Result := c_num_channels (item)
		end

	samples_per_sec: INTEGER
			--
		do
			Result := c_samples_per_sec (item)
		end

	bits_per_sample: INTEGER
			--
		do
			Result := c_bits_per_sample (item)
		end

	average_bytes_per_sec: INTEGER
			--
		do
			Result := c_average_bytes_per_sec (item)
		end

	block_align: INTEGER
			--
		do
			Result := c_block_align (item)
		end

feature -- Element change

	set_format (a_format: INTEGER)
			--
		require
			valid_format: is_valid_format (a_format)
		do
			c_set_format (item, a_format)
		end

	set_num_channels (number: INTEGER)
			--
		do
			c_set_num_channels (item, number)
		end

	set_samples_per_sec (samples_per_sec_count: INTEGER)
			--
		do
			c_set_samples_per_sec (item, samples_per_sec_count)
		end

	set_bits_per_sample (bits: INTEGER)
			--
		do
			c_set_bits_per_sample (item, bits)
		end

	set_size_byte_count (size_byte_count: INTEGER)
			--
		do
			c_set_size_byte_count (item, size_byte_count)
		end

	set_block_align
			--
		do
			c_set_block_align (item, num_channels * bits_per_sample // 8)
		end

	set_average_bytes_per_sec
			--
		do
			c_set_average_bytes_per_sec (item, samples_per_sec * block_align)
		end

invariant

	valid_average_bytes_per_sec: c_average_bytes_per_sec (item) = c_samples_per_sec (item) * c_block_align (item)

	valid_block_align: c_block_align (item) = c_num_channels (item) * c_bits_per_sample (item) // 8

end

