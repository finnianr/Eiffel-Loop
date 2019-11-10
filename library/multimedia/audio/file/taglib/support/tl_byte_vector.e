note
	description: "Tl byte vector"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-10 19:33:01 GMT (Sunday 10th November 2019)"
	revision: "2"

class
	TL_BYTE_VECTOR

inherit
	EL_OWNED_CPP_OBJECT
		rename
			make_from_pointer as make
		export
			{EL_CPP_API} self_ptr
		end

	TL_BYTE_VECTOR_CPP_API

	EL_SHARED_ONCE_STRING_8

create
	make, make_empty

feature {NONE} -- Initialization

	make_empty
		do
			make (cpp_new)
		end

feature -- Conversion

	data: MANAGED_POINTER
		do
			create Result.share_from_pointer (data_pointer, size.to_integer_32)
		end

	i_th (index: NATURAL): CHARACTER
		require
			valid_index: 1 <= index and index <= size
		do
			Result := cpp_i_th (self_ptr, index - 1)
		end

	size: NATURAL
		do
			Result := cpp_size (self_ptr)
		end

	to_string: STRING
		do
			Result := empty_once_string_8
			Result.from_c_substring (data_pointer, 1, size.to_integer_32)
			Result := Result.twin
		end

feature -- Status query

	equals (str: STRING): BOOLEAN
		do
			if str.count = size.to_integer_32 then
				Result := starts_with (str)
			end
		end

	starts_with (str: STRING): BOOLEAN
		local
			i: INTEGER; area: like to_string.area
		do
			if str.count <= size.to_integer_32 then
				area := str.area
				Result := True
				from i := 1 until not Result or i > str.count loop
					Result := i_th (i.to_natural_32) = area [i - 1]
					i := i + 1
				end
			end
		end

feature -- Element change

	set_data (str: STRING)
		local
			to_c: ANY
		do
			to_c := str.to_c
			cpp_set_data (self_ptr, $to_c)
		end

feature {NONE} -- Implementation

	data_pointer: POINTER
		do
			Result := cpp_data (self_ptr)
		end

end
