note
	description: "Default desktop environment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-05 9:43:18 GMT (Tuesday 5th June 2018)"
	revision: "5"

class
	EL_DEFAULT_DESKTOP_ENVIRONMENT

inherit
	EL_DESKTOP_ENVIRONMENT_I

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
