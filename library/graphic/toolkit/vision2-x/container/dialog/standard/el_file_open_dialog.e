note
	description: "File open dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-14 12:58:01 GMT (Friday 14th August 2020)"
	revision: "3"

class
	EL_FILE_OPEN_DIALOG

inherit
	EV_FILE_OPEN_DIALOG
		rename
			set_position as set_absolute_position,
			set_x_position as set_absolute_x_position,
			set_y_position as set_absolute_y_position,
			file_path as file_path_string
		end

	EL_ZSTRING_ROUTINES undefine default_create, copy end

	EL_POSITIONABLE

	EL_MODULE_ZSTRING

	EL_MODULE_GUI

create
	make

feature {NONE} -- Initialization

	make (
		a_title, description: READABLE_STRING_GENERAL; extensions: ITERABLE [READABLE_STRING_GENERAL]
		last_open_dir: EL_DIR_PATH; a_open: like open
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
			file_path: EL_FILE_PATH
		do
			file_path := full_file_path
			open (file_path)
		end

feature {NONE} -- Internal attributes

	open: PROCEDURE [EL_FILE_PATH]

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
