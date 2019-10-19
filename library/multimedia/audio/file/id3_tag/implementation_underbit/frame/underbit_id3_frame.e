note
	description: "[
		Tag frame
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "3"

class
	UNDERBIT_ID3_FRAME

inherit
	ID3_FRAME

	EL_C_OBJECT
		export
			{UNDERBIT_ID3_TAG_INFO} self_ptr
		undefine
			out
		end

	UNDERBIT_ID3_C_API
		undefine
			out, dispose
		end

	UNDERBIT_ID3_CONSTANTS

create
	make, make_new

feature {EL_FACTORY_CLIENT} -- Initialization

	make (obj_ptr: POINTER; a_code: STRING)
			--
		local
			i: INTEGER
		do
			make_from_pointer (obj_ptr)
			code := a_code
			make_default
			from i := 1 until i > field_count loop
				field_list.extend (new_frame_field (i))
				i := i + 1
			end
			i := description_index
			if i > 0 and then attached {UNDERBIT_ID3_STRING_FIELD} field_list [i] as l_field then
				field_list [i] := l_field.as_description
			end
		end

	make_new (a_code: STRING)
			--
		do
			make_from_pointer (c_id3_frame_new (a_code.area.base_address))
		end

feature -- Access

	code: STRING

	field_count: INTEGER
			--
		do
			Result := c_id3_frame_nfields (self_ptr)
		end

feature -- Status query

	is_unique_file_id: BOOLEAN
			--
		do
			Result := code ~ "UFID"
		end

feature {UNDERBIT_ID3_TAG_INFO} -- Implementation

	description_index: INTEGER
		local
			list: like field_list
		do
			list := field_list
			from list.start until list.after or else Result > 0 loop
				if list.item.type = Field_type.string then
					Result := list.index
				end
				list.forth
			end
			if Result = field_count then
				Result := 0
			end
		end

	new_frame_field (index: INTEGER): ID3_FRAME_FIELD
		-- From: id3tag.h

		--	enum id3_field_type {
		--	 0  ID3_FIELD_TYPE_TEXTENCODING,
		--	 1  ID3_FIELD_TYPE_LATIN1,
		--	 2  ID3_FIELD_TYPE_LATIN1FULL,
		--	 3  ID3_FIELD_TYPE_LATIN1LIST,
		--	 4  ID3_FIELD_TYPE_STRING,
		--	 5  ID3_FIELD_TYPE_STRINGFULL,
		--	 6  ID3_FIELD_TYPE_STRINGLIST,
		--	 7  ID3_FIELD_TYPE_LANGUAGE,
		--	 8  ID3_FIELD_TYPE_FRAMEID,
		--	 9  ID3_FIELD_TYPE_DATE,
		--	10  ID3_FIELD_TYPE_INT8,
		--	11  ID3_FIELD_TYPE_INT16,
		--	12  ID3_FIELD_TYPE_INT24,
		--	13  ID3_FIELD_TYPE_INT32,
		--	14  ID3_FIELD_TYPE_INT32PLUS, (counts as binary data too)
		--	15  ID3_FIELD_TYPE_BINARYDATA
		--	};
		local
			l_pointer: POINTER; type: INTEGER
		do
			l_pointer := c_id3_frame_field (self_ptr, index - 1)
			type := c_id3_field_type (l_pointer)
			inspect type -- enum id3_field_type {
				when 0 then -- ID3_FIELD_TYPE_TEXTENCODING
					create {UNDERBIT_ID3_ENCODING_FIELD} Result.make (l_pointer)
				when 1 then -- ID3_FIELD_TYPE_LATIN1
					create {UNDERBIT_ID3_LATIN_1_FIELD} Result.make (l_pointer)
				when 2 then -- ID3_FIELD_TYPE_LATIN1FULL,
					create {UNDERBIT_ID3_FULL_LATIN_1_FIELD} Result.make (l_pointer)

--				when 3 then ID3_FIELD_TYPE_LATIN1LIST Missing implemenation in Underbit API

				when 4 then -- ID3_FIELD_TYPE_STRING
					create {UNDERBIT_ID3_STRING_FIELD} Result.make (l_pointer, encoding)

				when 5 then -- ID3_FIELD_TYPE_STRINGFULL
					create {UNDERBIT_ID3_FULL_STRING_FIELD} Result.make (l_pointer, encoding)

				when 6 then -- ID3_FIELD_TYPE_STRINGLIST
					create {UNDERBIT_ID3_STRING_LIST_FIELD} Result.make (l_pointer, encoding)

				when 7 then -- ID3_FIELD_TYPE_LANGUAGE
					create {UNDERBIT_ID3_LANGUAGE_FIELD} Result.make (l_pointer)

				when 8 then -- ID3_FIELD_TYPE_FRAMEID
					create {UNDERBIT_ID3_FRAME_ID_FIELD} Result.make (l_pointer)
				when 9 then -- ID3_FIELD_TYPE_DATE
					create {UNDERBIT_ID3_DATE_FIELD} Result.make (l_pointer)
				when 10 .. 13 then -- ID3_FIELD_TYPE_INT8 .. ID3_FIELD_TYPE_INT32
					create {UNDERBIT_ID3_INTEGER_FIELD} Result.make (l_pointer)

				when 14 .. 15 then -- ID3_FIELD_TYPE_BINARYDATA
					create {UNDERBIT_ID3_BINARY_DATA_FIELD} Result.make (l_pointer)

			else
				create {ID3_DEFAULT_FIELD} Result
			end
		end

end
