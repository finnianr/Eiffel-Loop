note
	description: "${description}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_AUDIO_PCM_SAMPLE

inherit
	MANAGED_POINTER
		rename
			make as make_bytes
		export
			{NONE} all
			{ANY} item
		end

feature {NONE} -- Initialization

	make
			--
		do
			make_bytes (Bytes)
		end

feature -- Access

	value: INTEGER
			--
		do
			Result := read_value - Bias
		end

	to_real_unit: REAL
			--
		do
			Result := (value / Max_value).truncated_to_real
		end

	to_double_unit: DOUBLE
			--
		do
			Result := value / Max_value
		end

feature -- Element change

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

	set_from_real_unit (a_unit_value: REAL)
			--
		do
			set_value ((a_unit_value * Max_value).rounded)
		end

	set_from_double_unit (a_unit_value: DOUBLE)
			--
		do
			set_value ((a_unit_value * Max_value).rounded)
		end

feature {NONE} -- Implementation

	read_value: INTEGER
			--
		deferred
		end

	put_value (a_value: like value)
			--
		deferred
		end

feature -- Constants

	Bytes: INTEGER
			-- Number of bytes
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

	Bias: INTEGER
			--
		deferred
		end

end
