note
	description: "Reflected field conforming to [$source COLLECTION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-21 14:56:04 GMT (Friday 21st May 2021)"
	revision: "8"

class
	EL_REFLECTED_COLLECTION [G]

inherit
	EL_REFLECTED_REFERENCE [COLLECTION [G]]
		rename
			value as collection
		redefine
			make
		end

	EL_MODULE_CONVERT_STRING

create
	make

feature {NONE} -- Initialization

	make (a_object: EL_REFLECTIVE; a_index: INTEGER_32; a_name: STRING_8)
		require else
			is_string_convertible: Convert_string.has (({G}).type_id)
		do
			Precursor (a_object, a_index, a_name)
			if attached {like new_item} Read_functions_table [{G}] as function then
				new_item := function
			end
			item_type := {G}
		end

feature -- Status query

	has_character_data: BOOLEAN
		do
			Result := Collection_type_table.is_character_data (item_type.type_id)
		end

feature -- Basic operations

	extend_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			if attached new_item as l_new_item then
				collection (a_object).extend (l_new_item (readable))

			elseif attached {G} Convert_string.to_type (readable.read_string, item_type) as new then
				collection (a_object).extend (new)
			end
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

	new_read_functions: ARRAY [FUNCTION [EL_READABLE, ANY]]
		do
			Result := <<
--				commented out `read_boolean' as it appears as PREDICATE [TUPLE [EL_READABLE]]
--				agent {EL_READABLE}.read_boolean,

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

			elseif attached {EL_PATH} item as path then
				Result := path.to_string
			else
				Result := item.out
			end
		end

feature {NONE} -- Internal attributes

	new_item: detachable FUNCTION [EL_READABLE, G]

	item_type: TYPE [ANY]

feature {NONE} -- Constants

	Read_functions_table: EL_HASH_TABLE [FUNCTION [EL_READABLE, ANY], TYPE [ANY]]
		local
			read_functions: like new_read_functions
		once
			read_functions := new_read_functions
			create Result.make_size (read_functions.count)
			-- add `read_boolean' manually otherwise the type is `PREDICATE [TUPLE [EL_READABLE]]'
			Result [{BOOLEAN}] := agent {EL_READABLE}.read_boolean
			across read_functions as function loop
				Result.extend (function.item, function.item.generating_type.generic_parameter_type (2))
			end
		end
end