note
	description: "Fully qualified domain name of machine (UNIX only)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-22 10:10:46 GMT (Wednesday 22nd May 2024)"
	revision: "1"

class
	EL_HOST_NAME_COMMAND

inherit
	EL_CAPTURED_OS_COMMAND
		rename
			make as make_command
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_command ("hostname --fqdn")
			execute
		end

feature -- Access

	name: STRING
		do
			Result := lines.first_or_empty
		end

end