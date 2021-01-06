note
	description: "Document node string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-06 17:22:21 GMT (Wednesday 6th January 2021)"
	revision: "5"

class
	EL_DOCUMENT_NODE_STRING

inherit
	EL_UTF_8_STRING
		export
			{NONE} all
			{ANY} append_count_from_c, wipe_out, is_valid_as_string_8, set_from_general
		redefine
			make, as_string_32, to_string_32, as_string_8, to_string_8,
			raw_string, raw_string_8, raw_string_32
		end

	EL_READABLE
		rename
			read_character_8 as to_character_8,
			read_character_32 as to_character_32,
			read_integer_8 as to_integer_8,
			read_integer_16 as to_integer_16,
			read_integer_32 as to_integer,
			read_integer_64 as to_integer_64,
			read_natural_8 as to_natural_8,
			read_natural_16 as to_natural_16,
			read_natural_32 as to_natural,
			read_natural_64 as to_natural_64,
			read_real_32 as to_real,
			read_real_64 as to_double,
			read_string as to_string,
			read_string_8 as to_string_8,
			read_string_32 as to_string_32,
			read_boolean as to_boolean,
			read_pointer as to_pointer
		undefine
			copy, is_equal, out
		end

	EL_CACHED_FIELD_READER
		rename
			read_string as put_string_into,
			read_string_8 as put_string_8_into,
			read_string_32 as put_string_32_into
		undefine
			copy, is_equal, out
		end

	EL_ENCODEABLE_AS_TEXT
		rename
			make as make_encodeable
		export
			{NONE} all
		undefine
			copy, is_equal, out
		end

	EL_XPATH_CONSTANTS
		undefine
			copy, is_equal, out
		end

create
	make_empty

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			make_default
			Precursor (n)
		end

feature -- Access

	name: EL_UTF_8_STRING

	type: INTEGER
		-- Node type id

	xpath_name (keep_ref: BOOLEAN): ZSTRING
			--
		do
			Result := once_empty_string
			inspect type
				when Node_type_element then
					if encoded_as_utf (8) then
						Result.append_utf_8 (name)
					else
						Result.append_string_general (name)
					end

				when Node_type_text then
					Result.append_raw_string_8 (Node_text)

				when Node_type_comment then
					Result.append_raw_string_8 (Node_comment)

				when Node_type_processing_instruction then
					Result.append_raw_string_8 (Node_processing_instruction)
					if encoded_as_utf (8) then
						Result.append_utf_8 (name)
					else
						Result.append_string_general (name)
					end
					Result.append_raw_string_8 (Node_processing_instruction_end)

			else
				Result.append_string_general (name)
			end
			if keep_ref then
				Result := Result.twin
			end
		end

feature -- To string type

	raw_string_8 (keep_ref: BOOLEAN): STRING_8
		do
			if encoded_as_utf (8) then
				Result := Precursor (keep_ref)
			else
				Result := once_copy_8 (Current)
			end
			if keep_ref then
				Result := Result.twin
			end
		end

	to_string: ZSTRING
		do
			Result := adjusted (True)
		end

	to_string_32, as_string_32: STRING_32
		do
			Result := adjusted_32 (True)
		end

	to_string_8, as_string_8: STRING_8
		do
			Result := adjusted_8 (True)
		end

feature -- Conversion

	to_character_32: CHARACTER_32
		local
			str_32: STRING_32; i, l_count: INTEGER; c: CHARACTER_32
		do
			str_32 := raw_string_32 (False)
			if str_32.count = 1 then
				Result := str_32 [1]
			else
				l_count := str_32.count
				from i := 1 until Result /= '%U' or else i > l_count loop
					c := str_32 [i]
					if not c.is_space then
						Result := c
					end
					i := i + 1
				end
			end
		end

	to_character_8: CHARACTER
		local
			nb, i: INTEGER; l_area: like area; c: CHARACTER
		do
			l_area := area
			if count = 1 then
				Result := l_area [0]
			else
				nb := count
				from i := 0 until Result /= '%U' or else i = nb loop
					c := l_area [i]
					if not c.is_space then
						Result := c
					end
					i := i + 1
				end
			end
		end

	to_pointer: POINTER
		do
		end

feature -- Element change

	set_type (a_type: INTEGER)
			--
		do
			type := a_type
		end

feature -- Basic operations

	put_string_into (a_set: EL_HASH_SET [ZSTRING])
		local
			member: ZSTRING
		do
			member := adjusted (False)
			if not a_set.has_key (member) then
				a_set.extend (member.twin)
			end
		end

	put_string_8_into (a_set: EL_HASH_SET [STRING_8])
		local
			member: STRING_8
		do
			member := adjusted_8 (False)
			if not a_set.has_key (member) then
				a_set.extend (member.twin)
			end
		end

	put_string_32_into (a_set: EL_HASH_SET [STRING_32])
		local
			member: STRING_32
		do
			member := adjusted_32 (False)
			if not a_set.has_key (member) then
				a_set.extend (member.twin)
			end
		end

feature {NONE} -- Implementation

	raw_string (keep_ref: BOOLEAN): ZSTRING
		do
			if encoded_as_utf (8) then
				Result := Precursor (keep_ref)
			else
				Result := once_copy_general (Current)
			end
		end

	raw_string_32 (keep_ref: BOOLEAN): STRING_32
		do
			if encoded_as_utf (8) then
				Result := Precursor (keep_ref)
			else
				Result := once_copy_general_32 (Current)
			end
		end

end