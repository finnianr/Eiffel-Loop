note
	description: "Menu driven console terminal shell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-18 9:33:00 GMT (Friday 18th May 2018)"
	revision: "6"

deferred class
	EL_COMMAND_SHELL

inherit
	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

feature {NONE} -- Initialization

	make_shell (name: ZSTRING)
		local
			table: like new_command_table
		do
			table := new_command_table
			create command_table.make_equal (table.count + 1)
			set_standard_options (command_table)
			across table as command loop
				command_table [command.key] := command.item
			end
			create menu.make (name, command_table.current_keys)
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

	set_standard_options (table: like new_command_table)
		do
			table [Default_zero_option] := agent set_user_exit
		end

	new_command_table: like command_table
		deferred
		end

	set_user_exit
		do
			user_exit := True
		end

feature {NONE} -- Internal attributes

	command_table: EL_ZSTRING_HASH_TABLE [PROCEDURE]

	menu: EL_COMMAND_MENU

	user_exit: BOOLEAN

feature {NONE} -- Constants

	Default_zero_option: ZSTRING
		once
			Result := "Quit"
		end

end
