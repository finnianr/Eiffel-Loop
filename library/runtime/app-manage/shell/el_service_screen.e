note
	description: "Service launched using the Unix screen command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-29 10:24:05 GMT (Sunday 29th October 2023)"
	revision: "12"

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

	bash_command: ZSTRING
		-- name of script with options arguments after .sh extension

	command_args: ZSTRING

	history_count: INTEGER

	name: ZSTRING

	sudo: BOOLEAN
		-- `True' if command should be run as super user

	is_service: BOOLEAN
		-- `True' if script run a service (affects generated script name)

feature -- Access

	menu_name (longest_name_count: INTEGER): ZSTRING
		local
			left_adjust: ZSTRING
		do
			left_adjust := space * (longest_name_count - name.count)
			Result := Name_template #$ [name, left_adjust, transition_name]
		end

	script_name: ZSTRING
		-- script name of `bash_command' if it has .sh extension
		-- else a generated service name derived from `name'
		require
			is_script: is_script
		local
			extension_index, index_after: INTEGER; dot_sh: ZSTRING
		do
			if is_script then
				if bash_command.count > 0 then
					dot_sh := ".sh"
					extension_index := bash_command.substring_index (dot_sh, 1)
					index_after := extension_index + dot_sh.count
				-- check for arguments after name
					if index_after <= bash_command.count and then bash_command.is_space_item (index_after) then
					-- name without the optional arguments after .sh
						Result := bash_command.substring (1, index_after - 1)
					else
						Result := bash_command
					end
				else
					Result := name.translated (" ", "_") + ".sh"
					Result.to_lower
					if is_service then
						Result.prepend_string_general ("run_service_")
					end
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
			Result := across << bash_script, bash_command >> as script some script.item.count > 0 end
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
				if bash_command.count > 0 then
					command_args := bash_command -- includes any argument after .sh
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

	Element_node_fields: STRING = "bash_command, bash_script"

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