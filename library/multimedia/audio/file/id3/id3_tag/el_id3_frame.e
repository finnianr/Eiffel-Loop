note
	description: "Summary description for {EL_ID3_FRAME}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_ID3_FRAME

inherit
	EL_CPP_OBJECT
		export
			{EL_ID3_INFO_I} self_ptr
		redefine
			out
		end

	EL_ID3_FIELD_TYPES
		undefine
			out
		end

	EL_ID3_ENCODINGS
		export
			{NONE} all
		undefine
			out
		end

	EL_MODULE_TAG
		undefine
			out
		end

feature {NONE} -- Initialization

	make_with_code (a_code: STRING)
			--
		deferred
		end

feature -- Access

	code: STRING
			--
		deferred
		end

	out: STRING
			--
		do
			create Result.make_empty
			across field_list as field loop
				if field.cursor_index > 1 then
					Result.append_character (' ')
				end
				if field.item.type = Type_string_data and then code ~ once "COMM" then
					Result.append (field.item.string.to_latin_1)
				else
					Result.append_character ('[')
					Result.append_string (field.item.type_name)
					Result.append_string (": ")
					if field.item.type = Type_encoding then
						Result.append_string (Encoding_names [field.item.integer])

					elseif field.item.is_string then
						Result.append (field.item.string.to_latin_1)

					elseif field.item.is_integer then
						Result.append_integer (field.item.integer)

					elseif field.item.type = Type_binary_data then
						Result.append_string ("size = ")
						Result.append_integer (field.item.binary_data.count)
					end
					Result.append_character (']')
				end
			end
		end

	out_z: ZSTRING
		do
			Result := out
		end

	string: ZSTRING
		do
			Result := string_of_type (Type_string_data)
		end

	data_string: STRING
			--
		local
        	l_data: MANAGED_POINTER
        	c_data: C_STRING
		do
        	l_data := binary_data
        	create c_data.make_shared_from_pointer_and_count (l_data.item, l_data.count)
        	Result := c_data.substring (1, c_data.count)
		end

	binary_data: MANAGED_POINTER
			--
		local
			l_index: INTEGER
		do
			l_index := index_of_type (Type_binary_data)
			if l_index > 0 then
				Result := field_list.i_th (l_index).binary_data
			else
				create Result.make (0)
			end
		end

	language: ZSTRING
		do
			Result := string_of_type (Type_language)
		end

	key, description: ZSTRING
		do
			Result := string_of_type (Type_description)
		end

	encoding: INTEGER
			--
		deferred
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

	field_list: FIXED_LIST [EL_ID3_FRAME_FIELD]
			--
		deferred
		end

feature -- Element change

	set_string (str: ZSTRING)
			--
		do
			set_string_of_type (Type_string_data, str)
		end

	set_data_string (str: like data_string)
			--
		require
			valid_type_exists: across field_list as field some field.item.type = Type_binary_data end
		do
			set_binary_data (create {MANAGED_POINTER}.make_from_pointer (str.area.base_address, str.count))
		ensure
			is_set: not str.is_empty implies str ~ data_string -- Bug in libid3, cannot set an empty data string
		end

	set_binary_data (value: like binary_data)
		require
			valid_type_exists: across field_list as field some field.item.type = Type_binary_data end
		local
			index: INTEGER
		do
			index := index_of_type (Type_binary_data)
			if index > 0 then
				field_list.i_th (index).set_binary_data (value)
			end
		end

	set_language (str: ZSTRING)
			--
		do
			set_string_of_type (Type_language, str)
		end

	set_description (str: ZSTRING)
			--
		do
			set_string_of_type (Type_description, str)
		ensure
			is_set: description ~ str
		end

	set_encoding (a_encoding: INTEGER)
			--
		do
			if is_encodable and then encoding /= a_encoding then
				across field_list as field loop
					field.item.set_encoding (a_encoding)
				end
			end
		end

feature -- Status query

	is_encodable: BOOLEAN
			--
		do
			Result := across field_list as field some field.item.is_encoding end
		end

feature {EL_ID3_INFO} -- Implementation

	set_string_of_type (type: INTEGER; value: ZSTRING)
		local
			index: INTEGER
		do
			index := index_of_type (type)
			if index > 0 then
				field_list.i_th (index).set_string (value)
			end
		end

	string_of_type (type: INTEGER): ZSTRING
		local
			index: INTEGER
		do
			create Result.make_empty
			index := index_of_type (type)
			if index > 0 then
				Result := field_list.i_th (index).string
			end
		end

	index_of_type (type: INTEGER): INTEGER
		do
			from field_list.start until Result > 0 or field_list.after loop
				if field_list.item.type = type then
					Result := field_list.index
				else
					field_list.forth
				end
			end
		end

	field_type_binary_data: INTEGER
		deferred
		end

end