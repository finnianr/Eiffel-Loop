note
	description: "Note editor test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-09 12:11:16 GMT (Sunday 9th January 2022)"
	revision: "26"

class
	NOTE_EDITOR_TEST_SET

inherit
	COPIED_SOURCES_TEST_SET
		undefine
			new_lio
		redefine
			on_prepare, selected_files
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		undefine
			default_create
		end

	EL_FILE_OPEN_ROUTINES

	EIFFEL_LOOP_TEST_ROUTINES

	NOTE_CONSTANTS
		undefine
			default_create
		end

	EL_EIFFEL_KEYWORDS
		undefine
			default_create
		end

	EL_MODULE_USER_INPUT

	EL_MODULE_TIME

	EL_MODULE_LOG

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

	EL_SHARED_FIND_FILE_FILTER_FACTORY

feature {NONE} -- Initialization

	on_prepare
		do
			Precursor
			make_machine
			create file_out.make_with_name (file_list.first_path)
			create license_notes.make_from_file (Eiffel_loop_dir + "license.pyx")
			create operations_list.make (20)
			create editor.make (license_notes, operations_list)
		end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("editor_with_new_class", agent test_editor_with_new_class)
		end

feature -- Tests

	test_editor_with_new_class
		local
			encoding, encoding_after: STRING; crc: NATURAL
			old_revision, new_revision: INTEGER_REF
		do
			log.enter ("test_editor")
			across file_list as path loop
				restore_default_fields (path.item)

				encoding := encoding_name (path.item); crc := crc_32 (path.item)
				editor.set_file_path (path.item)
				editor.edit
				encoding_after := encoding_name (path.item)
				assert ("encoding has not changed", encoding.is_equal (encoding_after))
				assert ("code has not changed", crc = crc_32 (path.item))

				store_checksum (path.item)
				editor.edit
				assert ("not file changed", not has_changed (path.item))

				create old_revision; create new_revision
				across << old_revision, new_revision >> as revision loop
					do_once_with_file_lines (agent get_revision (?, revision.item), open_lines (path.item, Latin_1))
					if revision.cursor_index = 1 then
						if attached open (path.item, Closed) as file then
							file.stamp (Time.unix_date_time (create {DATE_TIME}.make_now_utc) + 5)
							editor.edit
						end
					end
				end
				assert ("revision incremented", new_revision ~ old_revision + 1)

			end
			test_encoding_samples
--			n := User_input.integer ("Return to finish")
			log.exit
		end

feature {NONE} -- Line states

	find_author (line: ZSTRING)
		local
			get_field: EL_COLON_FIELD_ROUTINES
		do
			if get_field.name (line) ~ Field.author then
				file_out.put_new_line
				file_out.put_string (Default_fields.joined_lines)
				file_out.put_new_line
				state := agent find_class
			else
				if line_number > 1 then
					file_out.put_new_line
				end
				file_out.put_string (line)
			end
		end

	find_class (line: ZSTRING)
		do
			if line.starts_with (Keyword_class) then
				state := agent find_end
				find_end (line)
			end
		end

	find_end (line: ZSTRING)
		do
			file_out.put_new_line; file_out.put_string (line)
		end

	get_revision (line: ZSTRING; revision: INTEGER_REF)
		local
			get_field: EL_COLON_FIELD_ROUTINES
		do
			if get_field.name (line) ~ Field.revision then
				if attached {INTEGER_REF} get_field.integer (line) as l_revision then
					revision.set_item (l_revision)
				end
				state := final
			end
		end

feature {NONE} -- Implementation

	crc_32 (file_path: FILE_PATH): NATURAL
		local
			source: STRING; crc: like crc_generator
		do
			crc := crc_generator
			source := OS.File_system.plain_text (file_path)
			source.remove_head (source.substring_index ("%Nclass", 1))
			crc.add_string_8 (source)
			Result := crc.checksum
		end

	encoding_name (file_path: FILE_PATH): STRING
		do
			Result := open_lines (file_path, Latin_1).encoding_name
		end

	restore_default_fields (file_path: FILE_PATH)
		local
			list: EL_ZSTRING_LIST
		do
			if attached open_lines (file_path, Latin_1) as lines then
				list := lines.list

				if list.count > 0 then
					create file_out.make_open_write (file_path)
					file_out.byte_order_mark.enable
					file_out.set_encoding_from_other (lines)
					file_out.put_bom

					do_with_lines (agent find_author, list)
					file_out.close
				end
			end
		end

	selected_files: ARRAY [STRING]
		do
			-- UTF-8 + Latin-1
			Result := << Encoding_sample.utf_8, Encoding_sample.latin_1 >>
		end

feature {NONE} -- Internal attributes

	file_out: EL_PLAIN_TEXT_FILE

	license_notes: LICENSE_NOTES

	editor: NOTE_EDITOR

	operations_list: like editor.operations_list

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := "test-data/sources"
		end

	Default_fields: EL_ZSTRING_LIST
		once
			create Result.make_with_lines ("[
				author: ""
				date: "$Date$"
				revision: "$Revision$"
			]")
			Result.indent (1)
		end

end