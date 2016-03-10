note
	description: "Summary description for {EL_COMMAND_ARGUMENT_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_COMMAND_ARGUMENT_LIST

inherit
	LINKED_LIST [STRING]
		rename
			make as make_list
		end

	EL_MODULE_ENVIRONMENT
		undefine
			is_equal, copy
		end

	EL_MODULE_STRING
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			set_default_command_option_prefix
			make_list
		end

feature -- Access

	command_option_prefix: STRING

feature -- Element change

	add_options_list (a_option_list: STRING)
			-- add list of space separated options
		require
			at_least_one_space: a_option_list.occurrences (' ') > 0
		do
			a_option_list.split (' ').do_if (
--			DO
				agent add_option,
--			IF
				agent (option :STRING): BOOLEAN
					do
						Result := not option.is_empty
					end
			)
		end

	add_option (a_option: STRING)
		do
			extend (command_option_prefix + a_option)
		end

	add_option_argument (a_option, argument: STRING)
		do
			extend (command_option_prefix + a_option)
			extend (argument)
		end

	add_path (a_path: PATH_NAME)
		do
			if is_path_latin1 then
				extend (String.latin1_as_utf8 (a_path))
			else
				-- Already encoded
				extend (a_path)
			end

		end

	add_path_option (a_option_prefix: STRING; a_path: PATH_NAME)
			-- add path with option prefix
		do
			add_option (a_option_prefix)
			if is_path_latin1 then
				last.append (String.latin1_as_utf8 (a_path))
			else
				-- Already encoded
				last.append (a_path)
			end
		end

	set_path_encoding (path_latin1: BOOLEAN)
		do
			is_path_latin1 := path_latin1
		end

	set_command_option_prefix (a_prefix: STRING)
		do
			command_option_prefix := a_prefix
		end

	set_default_command_option_prefix
		do
			command_option_prefix := Default_command_option_prefix
		end

feature -- Status query

	is_path_latin1: BOOLEAN
		-- paths encoded as latin1
		-- utf8 if false

feature {NONE} -- Constants

	Default_command_option_prefix: STRING
		once
			Result := Environment.Operating.Command_option_prefix.out
		end

end
