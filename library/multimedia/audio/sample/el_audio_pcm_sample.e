note
	description: "Audio PCM sample"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-21 12:44:08 GMT (Sunday 21st January 2024)"
	revision: "10"

deferred class
	EL_AUDIO_PCM_SAMPLE

inherit
	EL_ALLOCATED_C_OBJECT
		rename
			make_default as make,
			count as byte_count
		export
			{EL_MEMORY_ROUTINES} c_size_of, self_ptr
			{ANY} byte_count
		end

feature -- Access

	to_double_unit: DOUBLE
			--
		do
			Result := value / Max_value
		end

	to_real_unit: REAL
			--
		do
			Result := (value / Max_value).truncated_to_real
		end

	value: INTEGER
			--
		do
			Result := read_value - Bias
		end

feature -- Element change

	read_from (file: RAW_FILE)
		do
			file.read_to_managed_pointer (Current, 0, byte_count)
		end

	set_from_double_unit (a_unit_value: DOUBLE)
			--
		do
			set_value ((a_unit_value * Max_value).rounded)
		end

	set_from_real_unit (a_unit_value: REAL)
			--
		do
			set_value ((a_unit_value * Max_value).rounded)
		end

	set_value (a_value: like value)
			-- Set `value' to `a_value'.
		local
			clipped_value: INTEGER
		do
			clipped_value := a_value + Bias
			if clipped_value > Max_value then
				clipped_value := (Max_value - 1).to_integer

			elseif clipped_value < Min_value then
				clipped_value := Min_value

			end
			put_value (clipped_value)
		end

feature -- Basic operations

	write_to (file: RAW_FILE)
		do
			file.put_managed_pointer (Current, 0, byte_count)
		end

feature {NONE} -- Implementation

	put_value (a_value: like value)
			--
		deferred
		end

	read_value: INTEGER
			--
		deferred
		end

feature -- Constants

	Bias: INTEGER
			--
		deferred
		end

	Max_value: INTEGER_64
			--
		deferred
		end

	Min_value: INTEGER
			--
		deferred
		end

end