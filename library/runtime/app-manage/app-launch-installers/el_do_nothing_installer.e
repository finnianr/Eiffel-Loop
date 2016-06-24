note
	description: "Summary description for {EL_DO_NOTHING__INSTALLER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-15 14:36:50 GMT (Sunday 15th May 2016)"
	revision: "5"

class
	EL_DO_NOTHING_INSTALLER

inherit
	EL_APPLICATION_INSTALLER_I

create
 	make_default, make_from_file

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
