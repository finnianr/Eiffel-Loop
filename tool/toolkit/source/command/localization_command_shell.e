note
	description: "Localization command shell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-14 18:50:33 GMT (Tuesday 14th February 2023)"
	revision: "23"

class
	LOCALIZATION_COMMAND_SHELL

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell
		undefine
			new_lio
		end

	EL_MODULE_LIO

	EL_MODULE_OS

	EL_MODULE_PYXIS

	EL_MODULE_USER_INPUT

	EL_FILE_OPEN_ROUTINES

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (tree_dir: DIR_PATH)
		do
			make_shell ("LOCALIZATION", 10)
			create unchecked_translations.make (0)
			file_list := OS.file_list (tree_dir, "*.pyx")
		end

feature -- Constants

	Description: STRING = "Command shell to perform queries and edits on tree of Pyxis localization files"

feature -- Basic operations

	add_check_attribute
		do
			file_list.do_all (agent add_file_check_attribute)
		end

	find_unchecked
		local
			language: STRING
		do
			language := input_language
			unchecked_translations.wipe_out
			file_list.do_all (agent add_unchecked (language, ?))
			across unchecked_translations as unchecked loop
				lio.put_path_field ("Pyxis", unchecked.item.file_path)
				lio.tab_right
				lio.put_new_line
				across unchecked.item as name loop
					lio.put_line (name.item)
				end
				lio.tab_left
				lio.put_new_line
			end
		end

feature {EQA_TEST_SET} -- Implementation

	add_file_check_attribute (file_path: FILE_PATH)
		--  adds a check attribute after every field `lang = <language>', for example
		-- `lang = de; check = false'

		local
			line_list: EL_ZSTRING_LIST; encoding: NATURAL
			line, adjusted: ZSTRING
		do
			lio.put_path_field ("add_check_attribute", file_path)
			lio.put_new_line

			encoding := Pyxis.encoding (file_path)

			line_list := open_lines (file_path, encoding).as_list
			across line_list as list loop
				line := list.item; adjusted := line.adjusted
				if adjusted.starts_with (Lang_equals)
					and then not adjusted.has_substring ("check") and then not adjusted.ends_with (EN)
				then
					line.replace_substring (adjusted + "; check = false", line.leading_white_space + 1, line.count)
				end
			end

			if attached open (file_path, Write) as file_out then
				file_out.set_encoding (encoding)
				file_out.put_lines (line_list)
				file_out.close
			end
		end

	add_unchecked (language: STRING; file_path: FILE_PATH)
		local
			list: UNCHECKED_TRANSLATIONS_LIST
		do
			create list.make (language, file_path)
			if not list.is_empty then
				unchecked_translations.extend (list)
			end
		end

	input_language: STRING
		do
			Result := User_input.line ("Enter a language code")
			lio.put_new_line
		end

feature {EQA_TEST_SET} -- Internal attributes

	file_list: like OS.file_list

	unchecked_translations: EL_ARRAYED_LIST [UNCHECKED_TRANSLATIONS_LIST]

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