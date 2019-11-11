note
	description: "Tl byte vector"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 19:07:15 GMT (Monday 11th November 2019)"
	revision: "3"

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

	count: NATURAL
		do
			Result := cpp_size (self_ptr)
		end

	data: MANAGED_POINTER
		do
			create Result.share_from_pointer (data_pointer, count.to_integer_32)
		end

	i_th (index: NATURAL): CHARACTER
		require
			valid_index: 1 <= index and index <= count
		do
			Result := cpp_i_th (self_ptr, index - 1)
		end

	to_string: ZSTRING
		do
			Result := to_temporary_string (False)
		end

	to_string_8: STRING
		do
			Result := to_temporary_string (True)
		end

	to_temporary_string (keep_ref: BOOLEAN): STRING
		local
			i, l_count: NATURAL
		do
			Result := empty_once_string_8
			l_count := count
			from i := 1 until i > l_count loop
				Result.extend (i_th (i))
				i := i + 1
			end
			if keep_ref then
				Result := Result.twin
			end
		end

feature -- Status query

	equals (str: STRING): BOOLEAN
		do
			if str.count = count.to_integer_32 then
				Result := starts_with (str)
			end
		end

	starts_with (str: STRING): BOOLEAN
		local
			i: INTEGER; area: like {STRING}.area
		do
			if str.count <= count.to_integer_32 then
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
