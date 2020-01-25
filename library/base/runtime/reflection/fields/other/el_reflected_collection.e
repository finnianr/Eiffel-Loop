note
	description: "Reflected collection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-25 16:59:47 GMT (Saturday 25th January 2020)"
	revision: "5"

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

	to_string_list (a_object: EL_REFLECTIVE): EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
		local
			converter: EL_ITERABLE_CONVERTER [G, READABLE_STRING_GENERAL]
		do
			create converter
			Result := converter.new_linear_list (collection (a_object).linear_representation, agent to_string_general)
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

	to_string_general (item: G): READABLE_STRING_GENERAL
		do
			if attached {READABLE_STRING_GENERAL} item as str then
				Result := str
			else
				Result := item.out
			end
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
