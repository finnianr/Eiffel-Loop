note
	description: "[
		Command to generate class [$source RBOX_DATABASE_FIELDS] from C source file `rhythmdb.c'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-07 18:19:19 GMT (Tuesday 7th April 2020)"
	revision: "1"

class
	GENERATE_RBOX_DATABASE_FIELDS

inherit
	EL_COMMAND

	EVOLICITY_SERIALIZEABLE
		redefine
			make_default
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_default
		redefine
			make_default
		end

	EL_MODULE_LIO

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_c_source_path: EL_FILE_PATH)
		do
			c_source_path := a_c_source_path
			make_from_file ("workarea/rbox_database_fields.e")
		end

	make_default
		do
			create field_table.make_equal (50)
			create type_set.make_equal (7)
			Precursor {EL_PLAIN_TEXT_LINE_STATE_MACHINE}
			Precursor {EVOLICITY_SERIALIZEABLE}
		end

feature -- Basic operations

	execute
		local
			source_lines: EL_PLAIN_TEXT_LINE_SOURCE
		do
			create source_lines.make (c_source_path)
			do_once_with_file_lines (agent find_rhythmdb_properties, source_lines)
			lio.put_path_field ("Writing", output_path)
			serialize
		end

feature {NONE} -- Line states

	compile_table (line: ZSTRING)
		local
			list: EL_ZSTRING_LIST; type: ZSTRING
		do
			if line.has_substring (Terminator) then
				state := final
			else
				line.adjust
				create list.make_with_csv (line)
				if list.count >= 3 then
					list.i_th (3).prune_all_trailing (')')
					type := list.i_th (2).as_lower
					type [1] := type.item (1).as_upper
					type_set.put (type)
					field_table.extend (type_set.found_item, list [3])
				end
			end
		end

	find_entry_id (line: ZSTRING)
		do
			if line.has_substring (Entry_id) then
				state := agent compile_table
			end
		end

	find_rhythmdb_properties (line: ZSTRING)
		do
			if line.has_substring (Rhythmdb_properties) then
				state := agent find_entry_id
			end
		end

feature {EL_COMMAND_CLIENT} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["type_set", agent: like type_set do Result := type_set end],
				["field_table", agent: like field_table do Result := field_table end]
			>>)
		end

	Template: STRING = "[
		class RBOX_DATABASE_FIELDS

		feature {NONE} -- Constants

			Field_type_table: EL_HASH_TABLE [INTEGER, STRING]
				once
					create Result.make (<<
					#across $field_table as $field loop
						[$field.key, $field.item],
					#end
					>>)
				end

		#across $type_set as $type loop
			$type.item: INTEGER = $type.cursor_index

		#end

		end
	]"

feature {NONE} -- Internal attributes

	c_source_path: EL_FILE_PATH

	field_table: EL_ZSTRING_HASH_TABLE [ZSTRING]

	type_set: EL_HASH_SET [ZSTRING]

feature {EL_COMMAND_CLIENT} -- Constants

	Entry_id: ZSTRING
		once
			Result := "ENTRY_ID"
		end

	Rhythmdb_properties: ZSTRING
		once
			Result := "rhythmdb_properties"
		end

	Terminator: ZSTRING
		once
			Result := "{ 0, 0, 0, 0 }"
		end

end
