note
	description: "[
		Interface to menu driven console terminal shell. Requires implementation of `new_command_table' in
		descendant.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-03 13:49:43 GMT (Friday 3rd March 2023)"
	revision: "18"

deferred class
	EL_COMMAND_SHELL_I

inherit
	ANY

	EL_MODULE_LIO

feature {NONE} -- Initialization

	make (name: READABLE_STRING_GENERAL; a_row_count: INTEGER)
		do
			make_table
			create menu.make (name, command_table.current_keys, a_row_count)
		end

	make_table
		do
			if attached new_command_table as table then
				create command_table.make_size (table.count + 1)
				set_standard_options (command_table)
				across table as command loop
					command_table [command.key] := command.item
				end
			end
		end

feature -- Measurement

	option_count: INTEGER
		do
			Result := command_table.count
		end

feature -- Basic operations

	refresh
		-- refresh `command_table'
		do
			make (menu.name, menu.row_count)
		end

	run_command_loop
		local
			choice: INTEGER; option_input: EL_USER_INPUT_VALUE [INTEGER]
			invalid_option: ZSTRING
		do
			invalid_option := "No such option number: '%S'"
			create option_input.make_valid ("Enter option number", invalid_option, agent menu.valid_option)

			from until user_exit loop
				display_menu
				choice := option_input.value

				lio.put_labeled_string ("SELECTED", menu.option_key (choice))
				lio.put_new_line

				if command_table.has_key (menu.option_key (choice)) then
					command_table.found_item.apply
				end
			end
		end

feature -- Element change

	force_exit
		do
			user_exit := True
		end

feature {NONE} -- Implementation

	display_menu
		do
			menu.display
		end

	new_command_table: like command_table
		deferred
		end

	set_standard_options (table: like new_command_table)
		do
			table [Default_zero_option] := agent force_exit
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