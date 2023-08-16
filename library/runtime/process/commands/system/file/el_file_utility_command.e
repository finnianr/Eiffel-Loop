note
	description: "Fork a system utility operating on a path argument"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-22 11:45:24 GMT (Saturday 22nd July 2023)"
	revision: "2"

class
	EL_FILE_UTILITY_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [path: STRING]]
		rename
			make as make_parsed
		end

create
	 make

convert
	make ({STRING})

feature {NONE} -- Initialization

	make (name: STRING)
		do
			template := name + " $PATH"
			make_parsed
			set_forking_mode (True)
		end

feature -- Element change

	set_path (path: EL_PATH)
		do
			put_path (var.path, path)
		end

feature {NONE} -- Internal attributes

	template: STRING

end