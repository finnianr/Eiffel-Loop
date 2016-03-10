note
	description: "Summary description for {EL_DO_NOTHING__INSTALLER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-02-28 12:09:03 GMT (Friday 28th February 2014)"
	revision: "3"

class
	EL_DO_NOTHING_INSTALLER

inherit
	EL_APPLICATION_INSTALLER

create
	default_create, make_from_file

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
