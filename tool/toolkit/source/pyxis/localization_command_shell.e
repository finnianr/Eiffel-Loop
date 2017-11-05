note
	description: "Summary description for {PYXIS_TRANSLATION_CHECK}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-18 10:53:12 GMT (Wednesday 18th October 2017)"
	revision: "4"

class
	LOCALIZATION_COMMAND_SHELL

inherit
	EL_COMMAND_SHELL_COMMAND
		undefine
			new_lio
		end

	EL_MODULE_LIO

	EL_MODULE_OS

	EL_MODULE_USER_INPUT

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (tree_dir: EL_DIR_PATH)
		do
			make_shell
			file_list := OS.file_list (tree_dir, "*.pyx")
		end

feature -- Basic operations

	add_check_attribute
		do
			file_list.do_all (agent add_file_check_attribute)
		end

	find_unchecked
		local
			list: EL_ZSTRING_LIST; language: STRING
		do
			create list.make (0)
			language := input_language
			file_list.do_all (agent add_unchecked (list, language, ?))
		end

feature {EQA_TEST_SET} -- Implementation

	add_unchecked (list: EL_ZSTRING_LIST; language: STRING; file_path: EL_FILE_PATH)
		do
			list.append (create {UNCHECKED_TRANSLATIONS_LIST}.make (language, file_path))
		end

	add_file_check_attribute (file_path: EL_FILE_PATH)
		--  adds a check attribute after every field `lang = <language>', for example
		-- `lang = de; check = false'

		local
			lines: EL_ZSTRING_LIST; line, trim_line: ZSTRING
			line_source: EL_FILE_LINE_SOURCE; file_out: EL_PLAIN_TEXT_FILE
		do
			lio.put_path_field ("add_check_attribute", file_path)
			lio.put_new_line
			create line_source.make (file_path)
			create lines.make (100)
			from line_source.start until line_source.after loop
				line := line_source.item
				trim_line := line.stripped
				if trim_line.starts_with (Lang_equals)
					and then not trim_line.has_substring ("check") and then not trim_line.ends_with (EN)
				then
					lines.extend (line + "; check = false")
				else
					lines.extend (line)
				end
				line_source.forth
			end
			line_source.close

			create file_out.make_open_write (file_path)
			file_out.set_encoding_from_other (line_source)
			file_out.put_lines (lines)
			file_out.close
		end

	input_language: STRING
		do
			Result := User_input.line ("Enter a language code")
			lio.put_new_line
		end

feature {EQA_TEST_SET} -- Internal attributes

	file_list: like OS.file_list

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make (<<
				["Add check attribute", 	agent add_check_attribute],
				["Find unchecked items",	agent find_unchecked]
			>>)
		end

feature {NONE} -- Constants

	EN: ZSTRING
		once
			Result := "en"
		end

	Lang_equals: ZSTRING
		once
			Result := "lang = "
		end

end
