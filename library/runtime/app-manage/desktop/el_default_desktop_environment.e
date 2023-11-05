note
	description: "Default desktop environment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 15:09:57 GMT (Sunday 5th November 2023)"
	revision: "9"

class
	EL_DEFAULT_DESKTOP_ENVIRONMENT

inherit
	EL_DESKTOP_ENVIRONMENT_I

	EL_NEUTRAL_IMPLEMENTATION

create
	make_default

feature -- Basic operations

	install
			--
		do
		end

	uninstall
			--
		do
		end

feature {NONE} -- Implementation

	Command_args_template: STRING = "none"

end