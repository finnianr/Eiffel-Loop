note
	description: "Console routine log"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-31 16:23:57 GMT (Saturday 31st December 2022)"
	revision: "8"

class
	EL_CONSOLE_ROUTINE_LOG

inherit
	EL_ROUTINE_LOG

create
	make

feature -- Element change

	set_output (a_output: like output)
		do
			output := a_output
		end

feature {NONE} -- Initialization

	make (a_output: like output)
		do
			make_default
			output := a_output
		end

feature {EL_LOG_HANDLER} -- Internal attributes

	output: EL_CONSOLE_LOG_OUTPUT

end