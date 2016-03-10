note
	description: "Desktop item for launching application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:01 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_DESKTOP_LAUNCHER

inherit
	EL_DESKTOP_MENU_ITEM
		redefine
			make
		end

	EL_MODULE_STRING

create
	make

feature {NONE} -- Initialization

	make (a_name, a_comment: like name; a_icon_path: EL_FILE_PATH)
			--
		do
			Precursor (a_name, a_comment, a_icon_path)
			create command.make_empty
		end

feature -- Element change

	set_command (a_command: like command)
			--
		do
			command := a_command
		end

	set_command_args (a_command_args: like command_args)
			--
		do
			command_args := a_command_args
			String.subst_all_characters (command_args, '%N', ' ')
		end

feature -- Access

	command: EL_ASTRING

	command_args: EL_ASTRING

end
