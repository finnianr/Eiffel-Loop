note
	description: "Id3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-19 10:05:35 GMT (Wednesday 19th January 2022)"
	revision: "11"

deferred class
	ID3_FRAME

inherit
	ID3_SHARED_FRAME_FIELD_TYPES

	ID3_MODULE_TAG

	ID3_SHARED_ENCODING_ENUM

feature {NONE} -- Initialization

	make_new (a_code: STRING)
			--
		deferred
		end

	make_default
		do
			create field_list.make (field_count)
			across new_field_list as l_field loop
				field_list.extend (l_field.item)
			end
		end

feature -- Access

	code: STRING
			--
		deferred
		end

	integer: INTEGER
		do
			if attached {ID3_INTEGER_FIELD} field (Field_type.integer) as l_field then
				Result := l_field.integer
			end
		end

	string: ZSTRING
		do
			if attached {ID3_STRING_FIELD} field (Field_type.string) as l_field then
				Result := l_field.string

			elseif attached {ID3_STRING_LIST_FIELD} field (Field_type.string) as l_field then
				if l_field.count = 1 then
					Result := l_field.first
				else
					Result := l_field.list.joined_lines
				end
			else
				create Result.make (0)
			end
		end

	string_list: EL_ZSTRING_LIST
		do
			if attached {ID3_STRING_LIST_FIELD} field (Field_type.string_list) as l_field then
				Result := l_field.list
			else
				create Result.make (0)
			end
		end

	data_string: STRING
			--
		local
        	l_data: MANAGED_POINTER; c_data: C_STRING
		do
        	l_data := binary_data
        	create c_data.make_shared_from_pointer_and_count (l_data.item, l_data.count)
        	Result := c_data.substring (1, c_data.count)
		end

	binary_data: MANAGED_POINTER
			--
		do
			if attached {ID3_BINARY_DATA_FIELD} field (Field_type.binary_data) as l_field then
				Result := l_field.binary_data
			else
				create Result.make (0)
			end
		end

	language: STRING
		do
			if attached {ID3_LANGUAGE_FIELD} field (Field_type.language) as lang then
				Result := lang.string
			else
				create Result.make_empty
			end
		end

	latin_1_string: STRING
		do
			if attached {ID3_LATIN_1_STRING_FIELD} field (Field_type.latin_1_string) as l_field then
				Result := l_field.string
			else
				create Result.make (0)
			end
		end

	description: ZSTRING
		do
			if attached {ID3_DESCRIPTION_FIELD} field (Field_type.description) as l_field then
				Result := l_field.string
			else
				create Result.make_empty
			end
		end

	encoding: NATURAL_8
			--
		do
			if attached {ID3_ENCODING_FIELD} field (Field_type.encoding) as l_field then
				Result := l_field.encoding
			else
				Result := Encoding_enum.unknown
			end
		end

	encoding_name: STRING
			--
		do
			Result := Encoding_enum.name (encoding)
		end

	field_count: INTEGER
			--
		deferred
		end

	field_types: ARRAYED_LIST [STRING]
			--
		do
			create Result.make (field_list.count)
			from field_list.start until field_list.after loop
				Result.extend (field_list.item.type_name)
				field_list.forth
			end
		end

	field_list: ID3_FRAME_FIELD_LIST

feature -- Element change

	set_integer (n: INTEGER)
			--
		require
			field_exists: has_field (Field_type.integer)
		do
			if attached {ID3_INTEGER_FIELD} field (Field_type.integer) as l_field then
				l_field.set_integer (n)
			end
		end

	set_string (str: ZSTRING)
			--
		require
			field_exists: has_field (Field_type.string)
		do
			if attached {ID3_STRING_FIELD} field (Field_type.string) as l_field then
				l_field.set_string (str)
			end
		end

	set_latin_1_string (str: STRING)
			--
		require
			field_exists: has_field (Field_type.latin_1_string)
		do
			if attached {ID3_LATIN_1_STRING_FIELD} field (Field_type.latin_1_string) as l_field then
				l_field.set_string (str)
			end
		end

	set_data_string (str: like data_string)
			--
		require
			field_exists: has_field (Field_type.binary_data)
		do
			set_binary_data (create {MANAGED_POINTER}.make_from_pointer (str.area.base_address, str.count))
		ensure
			is_set: not str.is_empty implies str ~ data_string -- Bug in libid3, cannot set an empty data string
		end

	set_binary_data (value: like binary_data)
		require
			field_exists: has_field (Field_type.binary_data)
		do
			if attached {ID3_BINARY_DATA_FIELD} field (Field_type.binary_data) as l_field then
				l_field.set_binary_data (value)
			end
		end

	set_language (a_code: STRING)
			--
		require
			field_exists: has_field (Field_type.language)
			three_letter_code: a_code.count = 3
		do
			if attached {ID3_LANGUAGE_FIELD} field (Field_type.language) as l_field then
				l_field.set_string (a_code)
			end
		end

	set_description (str: ZSTRING)
			--
		require
			field_exists: has_field (Field_type.description)
		do
			if attached {ID3_DESCRIPTION_FIELD} field (Field_type.description) as l_field then
				l_field.set_string (str)
			end
		ensure
			is_set: description ~ str
		end

	set_encoding (a_encoding: NATURAL_8)
			--
		require
			field_exists: has_field (Field_type.encoding)
		do
			if is_encodable and then encoding /= a_encoding then
				if attached {ID3_ENCODING_FIELD} field (Field_type.encoding) as l_field then
					l_field.set_encoding (a_encoding)
				end
			end
		end

feature -- Status query

	is_encodable: BOOLEAN
			--
		do
			Result := has_field (Field_type.encoding)
		end

	has_binary_data: BOOLEAN
		do
			Result := has_field (Field_type.binary_data)
		end

	has_description: BOOLEAN
		do
			Result := has_field (Field_type.description)
		end

	has_language: BOOLEAN
		do
			Result := has_field (Field_type.language)
		end

	has_multi_line_string: BOOLEAN
		-- `True' if there is a string list field with more than one line
		do
			if attached {ID3_STRING_LIST_FIELD} field (Field_type.string_list) as l_field then
				Result := l_field.count > 1
			end
		end

	has_field (type: NATURAL_8): BOOLEAN
		require
			valid_type: Field_type.is_valid_value (type)
		do
			Result := field_list.has_type (type)
		end

feature {ID3_INFO} -- Implementation

	new_field_list: ITERABLE [ID3_FRAME_FIELD]
		deferred
		end

	field (type: NATURAL_8): ID3_FRAME_FIELD
		do
			Result := field_list.item_type (type)
		end

	field_type_binary_data: INTEGER
		deferred
		end

end