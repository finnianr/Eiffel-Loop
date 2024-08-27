note
	description: "[
		Name table for tuple fields in object conforming to ${EL_REFLECTIVE}
		
		Also contains a table of agent functions to convert `READABLE_STRING_GENERAL' 
		to adjusted `EL_SPLIT_READABLE_STRING_LIST' for initializing tuple field
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-27 13:05:41 GMT (Tuesday 27th August 2024)"
	revision: "6"

class
	EL_TUPLE_FIELD_TABLE

inherit
	EL_IMMUTABLE_STRING_8_TABLE
		rename
			make as make_indented
		redefine
			make_equal
		end

create
	make, make_empty, make_reversed

convert
	make ({STRING})

feature {NONE} -- Initialization

	make (a_manifest: READABLE_STRING_8)
		do
			make_indented ({EL_TABLE_FORMAT}.Indented_eiffel, a_manifest)
		end

	make_equal (n: INTEGER)
		do
			Precursor (n)
			converters_table := Default_converters_table
		end

feature -- Status change

	append_converters (array: like converters_table.MANIFEST_ARRAY)
		do
			if converters_table.is_empty then
				create converters_table.make (array)
			else
				converters_table.append_tuples (array)
			end
		end

feature -- Basic operations

	initialize_field (tuple: EL_REFLECTED_TUPLE)
		local
			tuple_name_list: EL_STRING_8_LIST
		do
			if has_key_8 (tuple.name) then
				create tuple_name_list.make_comma_split (found_item) -- ignores leading tab
				tuple.set_field_name_list (tuple_name_list)
			end
			if converters_table.has_key (tuple.name) then
				tuple.set_split_list_function (converters_table.found_item)
			end
		end

feature -- Contract Support

	valid_converters (fields_table: EL_OBJECT_FIELDS_TABLE): BOOLEAN
		do
			Result := across converters_table as table all fields_table.has_tuple_field (table.key) end
		end

feature {NONE} -- Internal attributes

	converters_table: like Default_converters_table

feature {NONE} -- Constants

	Default_converters_table: EL_HASH_TABLE [
		FUNCTION [READABLE_STRING_GENERAL, EL_SPLIT_READABLE_STRING_LIST [READABLE_STRING_GENERAL]], STRING
	]
		once
			create Result.make_size (0)
		end
end