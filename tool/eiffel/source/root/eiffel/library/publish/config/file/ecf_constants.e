note
	description: "Constants for [$source EIFFEL_CONFIGURATION_FILE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-11 10:08:08 GMT (Saturday 11th June 2022)"
	revision: "1"

deferred class
	ECF_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

	EL_STRING_8_CONSTANTS

	SHARED_CLASS_PATH_TABLE

feature {NONE} -- Xpath constants

	Attribute_location: STRING = "location"

	Attribute_recursive: STRING = "recursive"

	Element_cluster: STRING = "cluster"

	Xpath_mapping: STRING = "/system/target/mapping"

feature {NONE} -- Constants

	Default_alias_table: EL_ZSTRING_HASH_TABLE [ZSTRING]
		once
			create Result.make_equal (0)
		end

	Symbol: TUPLE [dot, star_dot_e, parent_dir, relative_location: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "., *.e, ../, $|")
		end

	Library: ZSTRING
		once
			Result := "library"
		end

	Mapping: TUPLE [old_name, new_name: STRING]
		once
			create Result
			Tuple.fill (Result, "old_name, new_name")
		end

	See_details: TUPLE [begins, ends: ZSTRING]
		once
			create Result
			Result.begins := "See "
			Result.ends := " for details"
		end

	Y_plural: ZSTRING
		once
			Result := "ies"
		end

end