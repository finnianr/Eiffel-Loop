note
	description: "[
		Tag frame
		C++ memory managed by IDTHREE_TAG owner
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "3"

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
		local
			field_iterator: LIBID3_FRAME_FIELD_ITERATOR
		do
			Precursor (cpp_ptr)
			make_default
			create field_iterator.make (agent create_field_iterator, Current)
			from field_iterator.start until field_iterator.after loop
				field_list.extend (field_iterator.item)
				field_iterator.forth
			end
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
			Result := cpp_field_count (self_ptr)
		end

feature -- Status query

	is_unique_file_id: BOOLEAN
			--
		do
			Result := id_number = Frame_id_table [Tag.Unique_file_ID]
		end

feature {NONE} -- Implementation

	Field_type_binary_data: INTEGER
		do
			Result := FN_data
		end

	create_field_iterator: POINTER
			--
		do
			Result := cpp_iterator (self_ptr)
		end

	is_c_call_ok, is_field_changed: BOOLEAN

end
