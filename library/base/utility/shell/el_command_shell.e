note
	description: "Menu driven console terminal shell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-19 8:38:41 GMT (Monday 19th September 2016)"
	revision: "2"

deferred class
	EL_COMMAND_SHELL

inherit
	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

feature {NONE} -- Initialization

	make_shell
		local
			table: like new_command_table
		do
			table := new_command_table
			create command_table.make_equal (table.count + 1)
			command_table [Default_zero_option] := agent set_user_exit
			across table as command loop
				command_table [command.key] := command.item
			end
			create menu.make (command_table.current_keys)
		end

feature -- Basic operations

	run_command_loop
		local
			n: INTEGER
		do
			from until user_exit loop
				menu.display
				n := User_input.integer ("Enter option number")
				if menu.valid_option (n) then
					lio.put_new_line
					lio.put_labeled_string ("SELECTED", menu.option_key (n))
					lio.put_new_line

					command_table.item (menu.option_key (n)).apply
				else
					lio.put_integer_field ("Invalid option", n)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Implementation

	new_command_table: like command_table
		deferred
		end

	set_user_exit
		do
			user_exit := True
		end

feature {NONE} -- Internal attributes

	command_table: EL_ZSTRING_HASH_TABLE [PROCEDURE [ANY, TUPLE]]

	menu: EL_COMMAND_MENU

	user_exit: BOOLEAN

feature {NONE} -- Constants

	Default_zero_option: ZSTRING
		once
			Result := "Quit"
		end

end
