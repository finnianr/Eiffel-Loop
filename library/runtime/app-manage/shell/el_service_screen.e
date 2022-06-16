note
	description: "Service launched using the Unix screen command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 10:07:16 GMT (Thursday 16th June 2022)"
	revision: "6"

class
	EL_SERVICE_SCREEN

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			xml_naming as eiffel_naming
		redefine
			on_context_exit
		end

	EL_MODULE_EXECUTABLE; EL_MODULE_TUPLE

create
	make_default

feature -- Configuration

	bash_script: ZSTRING

	command_args: ZSTRING

	history_count: INTEGER

	name: ZSTRING

	sudo: BOOLEAN
		-- `True' if command should be run as super user

feature -- Access

	menu_name (longest_name_count: INTEGER): ZSTRING
		local
			s: EL_ZSTRING_ROUTINES; left_adjust: ZSTRING
		do
			left_adjust := s.n_character_string (' ', longest_name_count - name.count)
			Result := Name_template #$ [name, left_adjust, transition_name]
		end

	script_name: ZSTRING
		require
			is_script: is_script
		do
			if is_script then
				Result := "run_service_" + name.as_lower + ".sh"
				Result.replace_character (' ', '_')
			else
				create Result.make_empty
			end
		end

	sort_name: ZSTRING
		-- sort alphabetically with active in top section

feature -- Status query

	is_script: BOOLEAN
		do
			Result := not bash_script.is_empty
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
				command_args := script_name
			end
			if sudo then
				command_args.prepend_string_general ("sudo ")
			end
			sort_name := Sort_prefix + name
		end

feature {NONE} -- Constants

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