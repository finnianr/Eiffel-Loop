note
	description: "File open dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-27 11:07:41 GMT (Saturday 27th January 2024)"
	revision: "10"

class
	EL_FILE_OPEN_DIALOG

inherit
	EV_FILE_OPEN_DIALOG
		rename
			file_path as file_path_string
		end

	EL_STRING_GENERAL_ROUTINES

	EL_MODULE_ACTION

create
	make

feature {NONE} -- Initialization

	make (
		a_title, description: READABLE_STRING_GENERAL; extensions: ITERABLE [READABLE_STRING_GENERAL]
		last_open_dir: DIR_PATH; a_open: like open
	)
		local
			extension_list: EL_ZSTRING_LIST; i: INTEGER
		do
			open := a_open
			create extension_list.make_from_general (extensions)
			from i := 1 until i > extension_list.count loop
				extension_list [i] := Star_dot + extension_list [i]
				i := i + 1
			end
			make_with_title (to_unicode_general (a_title))
			filters.extend ([
				extension_list.joined (';').to_unicode,
				Filter_template.substituted_tuple ([description, extension_list.joined_with_string ("; ")]).to_unicode
			])
			set_start_directory (last_open_dir)
			open_actions.extend (agent on_open)
		end

feature {NONE} -- Event handling

	on_open
		local
			file_path: FILE_PATH
		do
			file_path := full_file_path
			open (file_path)
		end

feature {NONE} -- Internal attributes

	open: PROCEDURE [FILE_PATH]

feature {NONE} -- Constants

	Filter_template: ZSTRING
		once
			Result := "%S (%S)"
		end
		
	Star_dot: ZSTRING
		once
			Result := "*."
		end

end