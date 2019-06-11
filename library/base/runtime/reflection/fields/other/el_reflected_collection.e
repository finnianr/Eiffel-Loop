note
	description: "Reflected collection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-11 9:26:36 GMT (Tuesday 11th June 2019)"
	revision: "3"

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
			has_read_function_for_type: Read_functions.has ({G})
		do
			Precursor (a_object, a_index, a_name)
			if attached {like new_item} Read_functions [{G}] as l_new_item then
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

feature {NONE} -- Internal attributes

	new_item: FUNCTION [EL_READABLE, G]

feature {NONE} -- Constants

	Read_functions: EL_HASH_TABLE [FUNCTION [EL_READABLE, ANY], TYPE [ANY]]
		once
			create Result.make (<<
				[{BOOLEAN}, agent {EL_READABLE}.read_boolean],

				[{CHARACTER_8}, agent {EL_READABLE}.read_character_8],
				[{CHARACTER_32}, agent {EL_READABLE}.read_character_32],

				[{INTEGER_8}, agent {EL_READABLE}.read_integer_8],
				[{INTEGER_16}, agent {EL_READABLE}.read_integer_16],
				[{INTEGER_32}, agent {EL_READABLE}.read_integer_32],
				[{INTEGER_64}, agent {EL_READABLE}.read_integer_64],

				[{NATURAL_8}, agent {EL_READABLE}.read_natural_8],
				[{NATURAL_16}, agent {EL_READABLE}.read_natural_16],
				[{NATURAL_32}, agent {EL_READABLE}.read_natural_32],
				[{NATURAL_64}, agent {EL_READABLE}.read_natural_64],

				[{REAL_32}, agent {EL_READABLE}.read_real_32],
				[{REAL_64}, agent {EL_READABLE}.read_real_64],

				[{STRING}, agent {EL_READABLE}.read_string_8],
				[{STRING_32}, agent {EL_READABLE}.read_string_32],
				[{ZSTRING}, agent {EL_READABLE}.read_string]
			>>)
		end
end
