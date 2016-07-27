note
	description: "Summary description for {EIFFEL_NOTE_EDITOR_TEST_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EIFFEL_NOTE_EDITOR_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
		redefine
			on_prepare
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		undefine
			default_create
		end

	EL_MODULE_USER_INPUT
		undefine
			default_create
		end

	EIFFEL_CONSTANTS
		undefine
			default_create
		end

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32
		undefine
			default_create
		end

feature -- Tests

	test_editor_with_new_class
		local
			n: INTEGER; encoding, encoding_after: STRING; crc: NATURAL
			file_path: EL_FILE_PATH
		do
			log.enter ("test_editor")
			across Sources as path loop
				file_path := Work_area_dir + path.item.base
				restore_default_fields (file_path)

				encoding := encoding_name (file_path); crc := crc_32 (file_path)
				editor.set_input_file_path (Work_area_dir + file_path.base)
				editor.edit
				encoding_after := encoding_name (file_path)
				assert ("encoding has not changed", encoding.is_equal (encoding_after))
				assert ("code has not changed", crc = crc_32 (file_path))

				store_checksum (file_path)
				editor.edit
				assert ("not file changed", not has_changed (file_path))
			end
			n := User_input.integer ("Return to finish")
			log.exit
		end

feature {NONE} -- Line states

	find_author (line: ZSTRING)
		do
			if colon_name (line).same_string ("author") then
				file_out.put_new_line
				file_out.put_string (Default_fields.joined_lines)
				file_out.put_new_line
				state := agent find_class
			else
				if line_number > 1 then
					file_out.put_new_line
				end
				file_out.put_string_z (line)
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

feature {NONE} -- Events

	on_prepare
		do
			Precursor
			make
			create file_out.make_with_name (Sources.item (1))
			create license_notes.make_from_file (Eiffel_loop_dir + "license.pyx")
			create editor.make (license_notes)

			across Sources as path loop
				OS.copy_file (path.item, Work_area_dir)
			end
		end

feature {NONE} -- Implementation

	crc_32 (file_path: EL_FILE_PATH): NATURAL
		local
			source: STRING; crc: like crc_generator
		do
			crc := crc_generator
			source := OS.File_system.plain_text (file_path)
			source.remove_head (source.substring_index ("%Nclass", 1))
			crc.add_string_8 (source)
			Result := crc.checksum
		end

	encoding_name (file_path: EL_FILE_PATH): STRING
		local
			source: EL_FILE_LINE_SOURCE
		do
			create source.make_latin (1, file_path)
			Result := source.encoding_name
		end

	restore_default_fields (file_path: EL_FILE_PATH)
		local
			source: EL_FILE_LINE_SOURCE; lines: EL_ZSTRING_LIST
		do
			create source.make_latin (1, file_path)
			lines := source.list

			create file_out.make_open_write (file_path)
			file_out.enable_bom
			file_out.set_encoding_from_other (source)
			file_out.put_bom

			do_with_lines (agent find_author, lines)
			file_out.close
		end

feature {NONE} -- Internal attributes

	file_out: EL_PLAIN_TEXT_FILE

	license_notes: LICENSE_NOTES

	editor: EIFFEL_NOTE_EDITOR

feature {NONE} -- Constants

	Default_fields: EL_ZSTRING_LIST
		once
			create Result.make_with_lines ("[
				author: ""
				date: "$Date$"
				revision: "$Revision$"
			]")
			Result.indent (1)
		end

	Sources: ARRAY [EL_FILE_PATH]
		-- Line with 'ñ' was giving trouble
		-- 	Id3_title: STRING = "La Copla Porteña"
		once
			Result := <<
				Eiffel_loop_dir + "test/source/benchmark/string/support/i_ching_hexagram_constants.e", -- UTF-8
				Eiffel_loop_dir + "test/source/test/os-command/audio_command_test_set.e"	-- Latin-1
			>>
		end

end

