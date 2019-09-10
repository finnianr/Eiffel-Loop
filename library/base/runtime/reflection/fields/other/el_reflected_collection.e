note
	description: "Reflected collection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-10 17:38:02 GMT (Tuesday 10th September 2019)"
	revision: "4"

class
	EL_REFLECTED_COLLECTION [G]

inherit
	EL_REFLECTED_REFERENCE [COLLECTION [G]]
		rename
			value as collection
		redefine
			make
		end

create
	make


feature {NONE} -- Initialization

	make (a_object: EL_REFLECTIVE; a_index: INTEGER_32; a_name: STRING_8)
		require else
			has_read_function_for_type: Read_functions_table.has ({G})
		do
			Precursor (a_object, a_index, a_name)
			if attached {like new_item} Read_functions_table [{G}] as l_new_item then
				new_item := l_new_item
			end
		end

feature -- Status query

	is_string_item: BOOLEAN
		do
			Result := String_collection_type_table.type_array.has (type_id)
		end

feature -- Basic operations

	extend_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			collection (a_object).extend (new_item (readable))
		end

feature -- Conversion

	to_string_list (a_object: EL_REFLECTIVE): ARRAYED_LIST [READABLE_STRING_GENERAL]
		local
			l_collection: like collection
			list: LINEAR [G]
		do
			l_collection := collection (a_object)
			if attached {FINITE [G]} l_collection as finite then
				list := l_collection.linear_representation
				create Result.make (finite.count)
				from list.start until list.after loop
					if attached {READABLE_STRING_GENERAL} list.item as str then
						Result.extend (str)
					else
						Result.extend (list.item.out)
					end
					list.forth
				end
			end
		end

feature {NONE} -- Implementation

	read_functions: ARRAY [FUNCTION [EL_READABLE, ANY]]
		do
			Result := <<
				agent {EL_READABLE}.read_character_8,
				agent {EL_READABLE}.read_character_32,

				agent {EL_READABLE}.read_integer_8,
				agent {EL_READABLE}.read_integer_16,
				agent {EL_READABLE}.read_integer_32,
				agent {EL_READABLE}.read_integer_64,

				agent {EL_READABLE}.read_natural_8,
				agent {EL_READABLE}.read_natural_16,
				agent {EL_READABLE}.read_natural_32,
				agent {EL_READABLE}.read_natural_64,

				agent {EL_READABLE}.read_real_32,
				agent {EL_READABLE}.read_real_64,

				agent {EL_READABLE}.read_string_8,
				agent {EL_READABLE}.read_string_32,
				agent {EL_READABLE}.read_string
			>>
		end

feature {NONE} -- Internal attributes

	new_item: FUNCTION [EL_READABLE, G]

feature {NONE} -- Constants

	Read_functions_table: EL_HASH_TABLE [FUNCTION [EL_READABLE, ANY], TYPE [ANY]]
		local
			l_read_functions: like read_functions
		once
			l_read_functions := read_functions
			create Result.make_size (l_read_functions.count)

			Result [{BOOLEAN}] := agent {EL_READABLE}.read_boolean
			across l_read_functions as function loop
				Result.extend (function.item, function.item.generating_type.generic_parameter_type (2))
			end
		end
end
