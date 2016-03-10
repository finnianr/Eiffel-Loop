note
	description: "Summary description for {EL_DO_NOTHING__INSTALLER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 10:26:53 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_DO_NOTHING_INSTALLER

inherit
	EL_APPLICATION_INSTALLER
		rename
			make_serializeable as make
		end

create
	default_create, make, make_from_file

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
