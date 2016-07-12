note
	description: "Menu driven console terminal shell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 10:14:22 GMT (Friday 8th July 2016)"
	revision: "5"

deferred class
	EL_COMMAND_SHELL

inherit
	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

feature {NONE} -- Initialization

	make_shell
		do
			command_table := new_command_table
			command_table.compare_objects
			menu := command_table.current_keys
		end

feature -- Basic operations

	run_command_loop
		local
			done: BOOLEAN; option: INTEGER
		do
			from until done loop
				put_menu
				option := User_input.integer ("Enter option number")
				if option = 0 then done := True elseif menu.valid_index (option) then
					lio.put_new_line
					lio.put_labeled_string ("SELECTED", menu [option])
					lio.put_new_line

					command_table.item (menu [option]).apply
				else
					lio.put_integer_field ("Invalid option", option)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Implementation

	put_menu
		do
			lio.put_line ("SELECT MENU OPTION")
			lio.put_labeled_string ("0", Default_zero_option)
			lio.put_new_line
			across menu as option loop
				lio.put_labeled_string (option.cursor_index.out, option.item)
				lio.put_new_line
			end
			lio.put_new_line
		end

	menu: like command_table.current_keys

	command_table: EL_ZSTRING_HASH_TABLE [PROCEDURE [ANY, TUPLE]]

	new_command_table: like command_table
		deferred
		end

feature {NONE} -- Constants

	Default_zero_option: ZSTRING
		once
			Result := "Quit"
		end

end
