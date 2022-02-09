note
	description: "Reflected field conforming to [$source COLLECTION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-08 20:28:37 GMT (Tuesday 8th February 2022)"
	revision: "12"

class
	EL_REFLECTED_COLLECTION [G]

inherit
	EL_REFLECTED_REFERENCE [COLLECTION [G]]
		rename
			value as collection
		redefine
			make, set_from_string
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
			item_type_id := ({G}).type_id
		end

feature -- Status query

	has_character_data: BOOLEAN
		do
			Result := Collection_type_table.is_character_data (item_type_id)
		end

feature -- Basic operations

	extend_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			if attached new_item as l_new_item then
				collection (a_object).extend (l_new_item (readable))

			elseif attached {G} Convert_string.to_type_of_type (readable.read_string, item_type_id) as new then
				collection (a_object).extend (new)
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; csv_string: READABLE_STRING_GENERAL)
		-- if collection conforms to type `CHAIN [G]' when {G} is character data type
		-- then fill with data from comma separated `csv_string' using left adjusted values
		do
			if attached {CHAIN [ANY]} collection (a_object) as chain then
				if Convert_string.is_convertible_list (item_type_id, csv_string, True) then
					chain.wipe_out
					Convert_string.append_to_chain (item_type_id, chain, csv_string, True)
				else
					check
						convertable_string: False
					end
				end
			end
		end

feature -- Conversion

	to_string_list (a_object: EL_REFLECTIVE): EL_ARRAYED_RESULT_LIST [READABLE_STRING_GENERAL, G]
		do
			create Result.make (collection (a_object), agent to_string_general)
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

	item_type_id: INTEGER

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