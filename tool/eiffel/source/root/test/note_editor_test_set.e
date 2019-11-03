note
	description: "Note editor test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-07 10:27:24 GMT (Monday 7th October 2019)"
	revision: "11"

class
	NOTE_EDITOR_TEST_SET

inherit
	EL_GENERATED_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
		redefine
			on_prepare
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		undefine
			default_create
		end

	EL_EIFFEL_LOOP_TEST_CONSTANTS

	NOTE_CONSTANTS
		undefine
			default_create
		end

	EL_EIFFEL_KEYWORDS
		undefine
			default_create
		end

	EL_MODULE_COLON_FIELD

	EL_MODULE_USER_INPUT

	EL_MODULE_TIME

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

feature -- Tests

	test_editor_with_new_class
		local
			n: INTEGER; encoding, encoding_after: STRING; crc: NATURAL
			file_path: EL_FILE_PATH; old_revision, new_revision: INTEGER_REF
			file: PLAIN_TEXT_FILE
		do
			log.enter ("test_editor")
			across Sources as path loop
				file_path := Work_area_dir + path.item.base
				restore_default_fields (file_path)

				encoding := encoding_name (file_path); crc := crc_32 (file_path)
				editor.set_file_path (Work_area_dir + file_path.base)
				editor.edit
				encoding_after := encoding_name (file_path)
				assert ("encoding has not changed", encoding.is_equal (encoding_after))
				assert ("code has not changed", crc = crc_32 (file_path))

				store_checksum (file_path)
				editor.edit
				assert ("not file changed", not has_changed (file_path))

				create old_revision; create new_revision
				across << old_revision, new_revision >> as revision loop
					do_once_with_file_lines (
						agent get_revision (?, revision.item), create {EL_PLAIN_TEXT_LINE_SOURCE}.make_latin (1, file_path)
					)
					if revision.cursor_index = 1 then
						create file.make_with_name (file_path)
						file.stamp (Time.unix_date_time (create {DATE_TIME}.make_now_utc) + 5)
						editor.edit
					end
				end
				assert ("revision incremented", new_revision ~ old_revision + 1)
			end
			n := User_input.integer ("Return to finish")
			log.exit
		end

feature {NONE} -- Line states

	find_author (line: ZSTRING)
		do
			if Colon_field.name (line) ~ Field.author then
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
		do
			if Colon_field.name (line) ~ Field.revision then
				if attached {INTEGER_REF} Colon_field.integer (line) as l_revision then
					revision.set_item (l_revision)
				end
				state := final
			end
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
			source: EL_PLAIN_TEXT_LINE_SOURCE
		do
			create source.make_latin (1, file_path)
			Result := source.encoding_name
		end

	restore_default_fields (file_path: EL_FILE_PATH)
		local
			source: EL_PLAIN_TEXT_LINE_SOURCE; lines: EL_ZSTRING_LIST
		do
			create source.make_latin (1, file_path)
			lines := source.list

			create file_out.make_open_write (file_path)
			file_out.byte_order_mark.enable
			file_out.set_encoding_from_other (source)
			file_out.put_bom

			do_with_lines (agent find_author, lines)
			file_out.close
		end

feature {NONE} -- Internal attributes

	file_out: EL_PLAIN_TEXT_FILE

	license_notes: LICENSE_NOTES

	editor: NOTE_EDITOR

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

