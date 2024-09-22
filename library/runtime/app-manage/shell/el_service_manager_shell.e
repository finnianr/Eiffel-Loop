note
	description: "Service manager shell based on the Unix screen command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 17:41:50 GMT (Sunday 22nd September 2024)"
	revision: "10"

class
	EL_SERVICE_MANAGER_SHELL

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell
		redefine
			make_table, display_menu
		end

	EL_EVENT_LISTENER
		rename
			notify as refresh
		end

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (name: READABLE_STRING_GENERAL; a_row_count: INTEGER; a_config_path: FILE_PATH)
		do
			config_path := a_config_path
			make_shell (name, a_row_count)
		end

	make_table
		do
			create config.make (config_path)
			Precursor
		end

feature {NONE} -- Constants

	Description: STRING = "Runs service management shell"

feature {NONE} -- Implementation

	display_menu
		do
			lio.put_line ("Enable screen scrolling: CTRL+a ESC")
			lio.put_line ("To disable: ESC")
			lio.put_new_line
			Precursor
			lio.put_integer_field ("Active services", config.screen_list.active_count)
			lio.put_new_line
		end

	new_command_table: EL_PROCEDURE_TABLE [ZSTRING]
		local
			screen: EL_SERVICE_SCREEN; longest_name_count: INTEGER
		do
			longest_name_count := config.screen_list.longest_name_count
			create Result.make (config.screen_list.count)
			across config.screen_list as list loop
				screen := list.item
				Result [screen.menu_name (longest_name_count)] := agent screen.resume_or_launch (Current)
			end
		end

feature {NONE} -- Internal attributes

	config: EL_SERVICE_CONFIGURATION

	config_path: FILE_PATH

end