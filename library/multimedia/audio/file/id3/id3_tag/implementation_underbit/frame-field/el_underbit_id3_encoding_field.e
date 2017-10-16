note
	description: "Summary description for {EL_UNDERBIT_ID3_ENCODING_FIELD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_UNDERBIT_ID3_ENCODING_FIELD

inherit
	EL_ID3_FRAME_FIELD
		redefine
			is_encoding
		end

	EL_UNDERBIT_ID3_TAG_CONSTANTS

	EL_UNDERBIT_C_API
		undefine
			dispose
		end

	EL_UNDERBIT_STRING_ROUTINES
		undefine
			dispose
		end

	EL_MODULE_UTF

	PLATFORM

create
	make

feature -- Initialization

	make (obj_ptr: POINTER)
			--
		do
			make_from_pointer (obj_ptr)
			create data_length.make ({PLATFORM}.Natural_32_bytes)
		end

feature -- Access

	encoding: INTEGER
			--
		do
			Result := c_id3_field_gettextencoding (self_ptr)
		end

	type: INTEGER
		local
			l_type: INTEGER
		do
			l_type := field_type
			if l_type = Field_type_text_encoding then
				Result := Type_encoding

			elseif l_type = Field_type_language then
				Result := Type_language

			elseif String_field_types.has (l_type) then
				Result := Type_string_data

			elseif l_type = Field_type_binary_data then
				Result := Type_binary_data

			elseif Integer_field_types.has (l_type) then
				Result := Type_integer

			end
		end

	field_type: INTEGER
		do
			Result := c_id3_field_type (self_ptr)
		end

	string: ZSTRING
		do
			create Result.make_empty
		end

	integer: INTEGER
			--
		do
			Result := c_id3_field_getint (self_ptr)
		end

	binary_data: MANAGED_POINTER
			--
		local
			length: INTEGER
			data_ptr: POINTER
		do
			data_ptr := c_id3_field_getbinarydata (self_ptr, data_length.item)
			length := data_length.read_integer_32 (0)
			create Result.share_from_pointer (data_ptr, length)
		end

feature -- Element change

	set_encoding (new_encoding: INTEGER)
		do
			c_call_status := c_id3_field_settextencoding (self_ptr, new_encoding)
		ensure then
			c_call_succeeded: c_call_status = 0
		end

	set_binary_data (data: MANAGED_POINTER)
			--
		do
			c_call_status := c_id3_field_setbinarydata (self_ptr, data.item, data.count)
		ensure then
			is_set: c_call_status = 0
		end

	set_string (str: like string)
		do
		end

feature -- Status query

	is_encoding: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation

	c_call_status: INTEGER

	data_length: MANAGED_POINTER

end