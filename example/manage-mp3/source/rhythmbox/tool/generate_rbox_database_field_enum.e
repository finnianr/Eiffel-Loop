note
	description: "[
		Command to generate class [$source RBOX_DATABASE_FIELD_ENUM] from C source file `rhythmdb.c'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-07 15:30:50 GMT (Thursday 7th May 2020)"
	revision: "3"

class
	GENERATE_RBOX_DATABASE_FIELD_ENUM

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

	EL_MODULE_STRING_8

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_c_source_path: EL_FILE_PATH)
		do
			c_source_path := a_c_source_path
			make_from_file ("workarea/rbox_database_field_enum.e")
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
		do
			do_once_with_file_lines (agent find_rhythmdb_properties, open_lines (c_source_path, Utf_8))
			lio.put_path_field ("Writing", output_path)
			serialize
		end

feature {NONE} -- Line states

	compile_table (line: ZSTRING)
		local
			list: EL_ZSTRING_LIST; type, name: ZSTRING
		do
			if line.has_substring (Terminator) then
				state := final
			else
				line.adjust
				create list.make_with_csv (line)
				if list.count >= 3 then
					name := list.i_th (3)
					name.prune_all_trailing (')')
					name.remove_head (1); name.remove_tail (1)
					type := list.i_th (2).as_lower
					type [1] := type.item (1).as_upper
					name.replace_character ('-', '_')
					type_set.put (type)
					field_table.extend (type_set.found_item, name)
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
		class
			RBOX_DATABASE_FIELD_ENUM

		inherit
			EL_ENUMERATION [NATURAL_16]
				rename
					import_name as from_kebab_case,
					export_name as to_kebab_case
				export
					{NONE} all
					{ANY} value, is_valid_value, name, list
				redefine
					initialize_fields
				end

		create
			make

		feature {NONE} -- Initialization

			initialize_fields
				do
				#across $field_table as $field loop
					$field.key := ($field.cursor_index).to_natural_16 |<< 8 | $field.item
				#end
				end

		feature -- Access

		#across $field_table as $field loop
			$field.key: NATURAL_16

		#end

		feature {NONE} -- Constants

			G_type_boolean: NATURAL_16 = 0

			G_type_double: NATURAL_16 = 0x1

			G_type_string: NATURAL_16 = 0x2

			G_type_uint64: NATURAL_16 = 0x4

			G_type_ulong: NATURAL_16 = 0x8

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
