note
	description: "Temporary string buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-08 9:45:37 GMT (Friday 8th November 2024)"
	revision: "8"

deferred class
	EL_STRING_BUFFER [S -> STRING_GENERAL create make end, READABLE -> READABLE_STRING_GENERAL]

inherit
	ANY

	EL_READABLE_STRING_GENERAL_ROUTINES_IMP
		export
			{NONE} all
		end

	EL_STRING_BIT_COUNTABLE [READABLE]

feature -- Access

	copied (str: READABLE): S
		require
			not_buffer: not is_same (str)
		deferred
		end

	copied_general (general: READABLE_STRING_GENERAL): S
		require
			not_buffer: not is_same (general)
		deferred
		end

	copied_lower (str: READABLE): S
		require
			not_buffer: not is_same (str)
		do
			Result := copied (str)
			to_lower (Result)
		end

	copied_substring (str: READABLE; start_index, end_index: INTEGER): S
		require
			not_buffer: not is_same (str)
		deferred
		end

	copied_substring_general (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): S
		require
			not_buffer: not is_same (general)
		deferred
		end

	copied_upper (str: READABLE): S
		require
			not_buffer: not is_same (str)
		do
			Result := copied (str)
			to_upper (Result)
		end

	empty: S
		deferred
		end

	integer_string (n: INTEGER_64): S
		deferred
		end

	sized (n: INTEGER): S
		deferred
		ensure
			valid_size: Result.count = n
		end

	sufficient (a_capacity: INTEGER): S
		do
			if buffer.capacity < a_capacity then
				resize (a_capacity)
			end
			Result := empty
		ensure
			big_enough: Result.capacity >= a_capacity
			is_empty: Result.is_empty
		end

	to_same (general: READABLE_STRING_GENERAL): S
		do
			if buffer.same_type (general) and then attached {S} general as str then
				Result := str
			else
				Result := copied_general (general)
			end
		end

feature -- Status query

	is_available: BOOLEAN
		-- `True' if available to borrow in a pool

feature -- Measurement

	capacity: INTEGER
		do
			Result := buffer.capacity
		end

feature -- Status change

	borrow
		do
			is_available := False
		end

	return
		do
			is_available := True
		end

feature -- Contract Support

	is_same (general: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := general = Buffer
		end

feature -- Conversion

	adjusted (str: READABLE): S
		require
			not_buffer: not is_same (str)
		local
			start_index, end_index: INTEGER
		do
			end_index := str.count - trailing_white_count (str)
			if end_index.to_boolean then
				start_index := leading_white_count (str) + 1
			else
				start_index := 1
			end
			Result := copied_substring (str, start_index, end_index)
		end

feature -- Basic operations

	resize (a_capacity: INTEGER)
		do
		-- Buffer might be once variable
			buffer.standard_copy (create {S}.make (a_capacity))
		end

feature {NONE} -- Implementation

	buffer: S
		deferred
		end

	leading_white_count (s: READABLE): INTEGER
		deferred
		end

	to_lower (str: S)
		deferred
		end

	to_upper (str: S)
		deferred
		end

	trailing_white_count (s: READABLE): INTEGER
		deferred
		end

end