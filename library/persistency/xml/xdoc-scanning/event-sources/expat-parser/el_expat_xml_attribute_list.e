note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_EXPAT_XML_ATTRIBUTE_LIST

inherit
	EL_XML_ATTRIBUTE_LIST
		redefine
			make
		end

	MANAGED_POINTER
		rename
			make as mp_make,
			make_from_pointer as copy_from_pointer,
			item as attribute_struct_ptr,
			append as append_pointer,
			resize as resize_pointer,
			count as byte_count,
			make_from_array as make_from_byte_array
		export
			{NONE} all
		undefine
			copy, is_equal
		end

	EL_MODULE_C_DECODER
		export
			{NONE} all
		undefine
			copy, is_equal
		end

	EL_MEMORY
		export
			{NONE} all
			{ANY} is_attached
		undefine
			default_create, dispose, is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			mp_make (Size_of_attribute_struct)
		end

feature -- Element change

	set_from_c_attributes_array (attributes_array_pointer: POINTER)
			--
		require
			attributes_array_pointer_attached: is_attached (attributes_array_pointer)
		local
			cursor_ptr: POINTER
		do
			if not is_attached (attribute_struct_ptr) then
				mp_make (Size_of_attribute_struct)
			end
			from
				reset
				cursor_ptr := attributes_array_pointer
				attribute_struct_ptr.memory_copy (cursor_ptr, Size_of_attribute_struct)
			until
				not is_attached (read_pointer (0))
			loop
				extend
				c_decoder.set_from_utf8 (node.name, read_pointer (0))
				c_decoder.set_from_utf8 (node.raw_content, read_pointer (Pointer_bytes))

				cursor_ptr := cursor_ptr + Size_of_attribute_struct
				attribute_struct_ptr.memory_copy (cursor_ptr, Size_of_attribute_struct)
			end
		end

feature {NONE} -- Constants

	Size_of_attribute_struct: INTEGER
			-- struct {
			--	char *name_s
			--  char *value_s
			-- }
		once
			Result := Pointer_bytes * 2
		end

end -- class EL_EXPAT_ATTRIBUTE_LIST

