note
	description: "Fork a system utility operating on a path argument"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 8:46:59 GMT (Tuesday 9th July 2024)"
	revision: "3"

class
	EL_FILE_UTILITY_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [path: STRING]]
		rename
			make as make_parsed
		redefine
			default_template
		end

create
	 make

convert
	make ({STRING})

feature {NONE} -- Initialization

	make (a_command_name: STRING)
		do
			command_name := a_command_name
			make_parsed
			set_forking_mode (True)
		end

feature -- Element change

	set_path (path: EL_PATH)
		do
			put_path (var.path, path)
		end

feature {NONE} -- Implementation

	default_template: STRING
		do
			Result := command_name + " $PATH"
		end

feature {NONE} -- Internal attributes

	command_name: STRING

end