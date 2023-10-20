note
	description: "Service launched using the Unix screen command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 16:22:38 GMT (Thursday 17th August 2023)"
	revision: "10"

class
	EL_SERVICE_SCREEN

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			field_included as is_any_field,
			xml_naming as eiffel_naming
		redefine
			on_context_exit
		end

	EL_MODULE_EXECUTABLE; EL_MODULE_TUPLE

	EL_CHARACTER_32_CONSTANTS

create
	make_default

feature -- Configuration

	bash_script: ZSTRING

	bash_script_name: ZSTRING
		-- name of script with options arguments after .sh extension

	command_args: ZSTRING

	history_count: INTEGER

	name: ZSTRING

	sudo: BOOLEAN
		-- `True' if command should be run as super user

feature -- Access

	menu_name (longest_name_count: INTEGER): ZSTRING
		local
			left_adjust: ZSTRING
		do
			left_adjust := space * (longest_name_count - name.count)
			Result := Name_template #$ [name, left_adjust, transition_name]
		end

	script_name: ZSTRING
		require
			is_script: is_script
		local
			extension_index, index_after: INTEGER
		do
			if is_script then
				if bash_script_name.count > 0 then
					extension_index := bash_script_name.substring_index (Bash_dot_extension, 1)
					index_after := extension_index + Bash_dot_extension.count
				-- check for arguments after name
					if index_after <= bash_script_name.count and then bash_script_name.is_space_item (index_after) then
					-- name without the optional arguments after .sh
						Result := bash_script_name.substring (1, index_after - 1)
					else
						Result := bash_script_name
					end
				else
					Result := "run_service_" + name.as_lower + ".sh"
					Result.replace_character (' ', '_')
				end
			else
				create Result.make_empty
			end
		end

	sort_name: ZSTRING
		-- sort alphabetically with active in top section

feature -- Status query

	is_active: BOOLEAN
		do
		end

	is_script: BOOLEAN
		do
			Result := across << bash_script, bash_script_name >> as script some script.item.count > 0 end
		end

feature -- Basic operations

	resume_or_launch (shell: EL_EVENT_LISTENER)
		do
			screen_command.execute
			shell.notify
		end

feature {NONE} -- Implementation

	new_command_parts: EL_ZSTRING_LIST
		do
			create Result.make_from_array (<< Screen >>)
			if history_count.to_boolean then
				Result.extend ("-h " + history_count.out)
			end
			Result.extend ("-U") -- Run screen in UTF-8 mode
			Result.extend ("-S") -- this option can be used to specify a meaningful name for the  session
			Result.extend (name.quoted (2))
			if is_script then
				Result.extend (command_args)
			else
				if command_args.count > 1 and then command_args [1] = '-' then
					Result.extend (Executable.name)
				end
				Result.extend (command_args)
			end
		end

	screen_command: EL_OS_COMMAND
		do
			create Result.make (new_command_parts.joined_words)
		end

feature {NONE} -- Event handler

	on_context_exit
			-- Called when the parser leaves the current context
		do
			if is_script then
				if bash_script_name.count > 0 then
					command_args := bash_script_name -- includes any argument after .sh
				else
					command_args := script_name
				end
			end
			if sudo then
				command_args.prepend_string_general ("sudo ")
			end
			sort_name := Sort_prefix + name
		end

feature {NONE} -- Constants

	Bash_dot_extension: ZSTRING
		once
			Result := ".sh"
		end

	Element_node_fields: STRING = "bash_script"

	Name_template: ZSTRING
		once
			Result := "%S %S(%S)"
		end

	Screen: ZSTRING
		once
			Result := "screen"
		end

	Sort_prefix: ZSTRING
		once
			Result := "B-"
		end

	Transition_name: ZSTRING
		once
			Result := "Launch"
		end

end
