note
	description: "Reflective meta data for classes that inherit [$source EL_REFLECTIVELY_SETTABLE_STORABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-10 11:01:59 GMT (Thursday 10th December 2020)"
	revision: "11"

class
	EL_STORABLE_CLASS_META_DATA

inherit
	EL_CLASS_META_DATA
		redefine
			Reference_type_tables
		end

create
	make

feature {NONE} -- Constants

	Reference_type_tables: ARRAY [EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_REFERENCE [ANY]]]
		once
			Result := <<
--				We check if fields conforms to `EL_STORABLE' first because some fields
--				may conform to both `EL_STORABLE' and `EL_MAKEABLE_FROM_STRING_GENERAL'. For example: `EL_UUID'
				Storable_type_table,
				String_type_table,
				String_convertable_type_table,
				Makeable_from_string_type_table,
				String_collection_type_table,
				Numeric_collection_type_table,
				Other_collection_type_table
			>>
		end
end