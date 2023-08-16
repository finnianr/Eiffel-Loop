note
	description: "[
		Interface to menu driven console terminal shell. Requires implementation of `new_command_table' in
		descendant.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-11 7:17:16 GMT (Friday 11th August 2023)"
	revision: "19"

deferred class
	EL_COMMAND_SHELL_I

inherit
	ANY

	EL_MODULE_LIO; EL_MODULE_USER_INPUT

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
			choice: INTEGER
		do
			from until user_exit loop
				display_menu
				choice := user_choice
				if choice.to_boolean then
					lio.put_labeled_string ("SELECTED", menu.option_key (choice))
					lio.put_new_line

					if command_table.has_key (menu.option_key (choice)) then
						command_table.found_item.apply
					end
				else
					force_exit
				end
			end
			on_user_quit
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
		end

	user_choice: INTEGER
		local
			option_input: ZSTRING; valid_input: BOOLEAN
		do
			from until valid_input loop
				option_input := User_input.line ("Enter option number")
				if option_input.is_character ('%/27/') then
					Result := 0; valid_input := True
				else
					if option_input.is_integer then
						Result := option_input.to_integer
					end
					if menu.valid_option (Result) then
						valid_input := True
					else
						lio.put_labeled_substitution ("Error", "no such option number: '%S'", [option_input])
						lio.put_new_line
					end
				end
			end
		end

feature {NONE} -- Event handling

	on_user_quit
		do
		end

feature {NONE} -- Internal attributes

	command_table: EL_PROCEDURE_TABLE [ZSTRING]

	menu: EL_COMMAND_MENU

	user_exit: BOOLEAN

end