note
	description: "TagLib byte vector (or array of bytes)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-11 14:32:11 GMT (Saturday 11th November 2023)"
	revision: "11"

class
	TL_BYTE_VECTOR

inherit
	EL_OWNED_CPP_OBJECT
		export
			{EL_CPP_API} self_ptr
		end

	TL_BYTE_VECTOR_CPP_API

	TL_SHARED_FRAME_ID_ENUM

	EL_SHARED_STRING_8_BUFFER_SCOPES

create
	make, make_from_pointer, make_empty

feature {NONE} -- Initialization

	make (a_data: MANAGED_POINTER)
		do
			make_from_pointer (cpp_new (a_data.item, a_data.count))
		end

	make_empty
		do
			make_from_pointer (cpp_new_empty)
		end

feature -- Access

	item: POINTER
		-- data item pointer
		do
			Result := cpp_data (self_ptr)
		end

	checksum: NATURAL
		do
			Result := cpp_checksum (self_ptr)
		end

	count: INTEGER
		do
			Result := cpp_size (self_ptr).to_integer_32
		end

	data: MANAGED_POINTER
		do
			create Result.share_from_pointer (item, count)
		end

	i_th (index: INTEGER): CHARACTER
		require
			valid_index: 1 <= index and index <= count
		do
			Result := cpp_i_th (self_ptr, (index - 1).to_natural_32)
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
					Result := i_th (i) = area [i - 1]
					i := i + 1
				end
			end
		end

feature -- Conversion

	to_frame_id_enum: NATURAL_8
		do
			Result := Frame_id.value (to_string_8)
		end

	to_string: ZSTRING
		do
			Result := to_string_8
		end

	to_string_8: STRING
		local
			i, l_count: INTEGER
		do
			l_count := count
			create Result.make_filled ('%U', l_count)
			if attached Result.area as area then
				from i := 1 until i > l_count loop
					area [i - 1] := i_th (i)
					i := i + 1
				end
			end
		end

feature -- Element change

	set_data_from_string (str: STRING)
		local
			to_c: ANY
		do
			to_c := str.to_c
			cpp_set_data_from_string (self_ptr, $to_c)
		ensure
			same_count: count = str.count
		end

	set_data (a_data: like data)
		do
			cpp_set_data (self_ptr, a_data.item, a_data.count)
		ensure
			same_count: count = a_data.count
		end

	set_from_frame_id (enum_code: NATURAL_8)
		do
			set_data_from_string (Frame_id.name (enum_code))
		end

end