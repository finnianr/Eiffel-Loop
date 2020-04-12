note
	description: "[
		Interface to menu driven console terminal shell. Requires implementation of `new_command_table' in
		descendant.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-11 11:28:54 GMT (Saturday 11th April 2020)"
	revision: "10"

deferred class
	EL_COMMAND_SHELL_I

inherit
	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

feature {NONE} -- Initialization

	make_shell (name: READABLE_STRING_GENERAL; a_row_count: INTEGER)
		local
			table: like new_command_table
		do
			table := new_command_table
			create command_table.make_equal (table.count + 1)
			set_standard_options (command_table)
			across table as command loop
				command_table [command.key] := command.item
			end
			create menu.make (name, command_table.current_keys, a_row_count)
		end

feature -- Basic operations

	run_command_loop
		local
			n: INTEGER; invalid: BOOLEAN
		do
			from until user_exit loop
				menu.display
				n := User_input.integer ("Enter option number")
				if menu.valid_option (n) then
					lio.put_new_line
					lio.put_labeled_string ("SELECTED", menu.option_key (n))
					lio.put_new_line

					if command_table.has_key (menu.option_key (n)) then
						command_table.found_item.apply
					else
						lio.put_labeled_string (menu.option_key (n), "not found")
						lio.put_new_line
						invalid := True
					end
				else
					invalid := True
				end
				if invalid then
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

	command_table: EL_PROCEDURE_TABLE [ZSTRING]

	menu: EL_COMMAND_MENU

	user_exit: BOOLEAN

feature {NONE} -- Constants

	Default_zero_option: ZSTRING
		once
			Result := "Quit"
		end

end
