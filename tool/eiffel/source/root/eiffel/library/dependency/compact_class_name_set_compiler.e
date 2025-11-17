note
	description: "[
		A memory optimized ${CLASS_NAME_SET_COMPILER} object that compiles class name sets compactly
		as globally unique ${IMMUTABLE_STRING_8} names that are not shared substrings.
		
		It also checks for class alias substitution
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-17 18:23:15 GMT (Monday 17th November 2025)"
	revision: "1"

class
	COMPACT_CLASS_NAME_SET_COMPILER

inherit
	CLASS_NAME_SET_COMPILER
		redefine
			on_class_name
		end

create
	make_from_zstring, make_from_file, make_alias_table

feature {NONE} -- Initialization

	make_alias_table (assignments_path: FILE_PATH)
		-- initialize global table `Alias_table' from a text data file with class alias mappings
		-- Example:
		-- 	DIR_PATH := EL_DIR_PATH
		-- 	DOUBLE := REAL_64

		require
			file_exists: assignments_path.exists
		local
			table: EL_IMMUTABLE_STRING_8_TABLE
		do
			create table.make_assignments (File.plain_text (assignments_path))
			across table as t loop
				Alias_table.extend (t.item, t.key)
			end
			create class_name_set.make_equal (1)
		end

feature {NONE} -- Events

	on_class_name (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
			class_name_set.put (new_global_name (Immutable_8.new_substring (area, i, count)))
		end

feature {NONE} -- Implementation

	new_global_name (a_name: IMMUTABLE_STRING_8): IMMUTABLE_STRING_8
		local
			l_name: IMMUTABLE_STRING_8
		do
			if Alias_table.has_key (a_name) then
				l_name := Alias_table.found_item
			else
				l_name := a_name
			end
			if attached Global_name_set as set then
				if not set.has_key (l_name) then
					set.put (create {IMMUTABLE_STRING_8}.make_from_string (l_name))
				end
				Result := set.found_item
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Constants

	Alias_table: EL_HASH_TABLE [IMMUTABLE_STRING_8, IMMUTABLE_STRING_8]
		-- alias name keys mapped to actual class names
		once
			create Result.make_equal (7)
		end

	Global_name_set: EL_HASH_SET [IMMUTABLE_STRING_8]
		once
			create Result.make_equal (100)
		end

end