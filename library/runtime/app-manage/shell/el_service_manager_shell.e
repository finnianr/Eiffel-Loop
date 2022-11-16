note
	description: "Service manager shell based on the Unix screen command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

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
			Precursor
			lio.put_integer_field ("Active services", config.active_screen_count)
			lio.put_new_line
		end

	new_command_table: EL_PROCEDURE_TABLE [ZSTRING]
		local
			screen: EL_SERVICE_SCREEN; longest_name_count: INTEGER
		do
			longest_name_count := config.longest_name_count
			create Result.make_equal (config.screen_count)
			across config.screen_list as list loop
				screen := list.item
				Result [screen.menu_name (longest_name_count)] := agent screen.resume_or_launch (Current)
			end
		end

feature {NONE} -- Internal attributes

	config: EL_SERVICE_CONFIGURATION

	config_path: FILE_PATH

end