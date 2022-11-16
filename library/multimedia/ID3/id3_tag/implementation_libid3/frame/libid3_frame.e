note
	description: "[
		Tag frame
		C++ memory managed by IDTHREE_TAG owner
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	LIBID3_FRAME

inherit
	ID3_FRAME

	EL_CPP_OBJECT
		export
			{LIBID3_TAG_INFO} self_ptr
		undefine
			out
		redefine
			make_from_pointer
		end

	LIBID3_ID3_FRAME_CPP_API

	LIBID3_CONSTANTS
		export
			{NONE} all
		end

create
	make_from_pointer, make_new

feature {NONE} -- Initialization

	make_from_pointer (cpp_ptr: POINTER)
			--
		do
			Precursor (cpp_ptr)
			make_default
		ensure then
			field_count_correct: field_list.count = field_count
		end

	make_new (a_code: STRING)
			--
		require else
			valid_id: Frame_id_table.has_key (a_code)
		do
			make_with_id (Frame_id_table [a_code])
		end

	make_with_id (type: INTEGER)
			--
		do
		   make_from_pointer (cpp_new (type))
		end

feature -- Access

	code: STRING
			--
		do
			create Result.make_from_c (cpp_id (self_ptr))
		end

	id_number: INTEGER
			--
		do
			Result := cpp_id_number (self_ptr)
		end

	field_count: INTEGER
			--
		do
			if is_attached (self_ptr) then
				Result := cpp_field_count (self_ptr)
			end
		end

feature -- Status query

	is_unique_file_id: BOOLEAN
			--
		do
			Result := id_number = Frame_id_table [Tag.Unique_file_ID]
		end

feature {NONE} -- Implementation

	new_field_list: LIBID3_FRAME_FIELD_LIST
		do
			create Result.make (Current, cpp_iterator (self_ptr))
		end

	Field_type_binary_data: INTEGER
		do
			Result := FN_data
		end

	is_c_call_ok, is_field_changed: BOOLEAN

end