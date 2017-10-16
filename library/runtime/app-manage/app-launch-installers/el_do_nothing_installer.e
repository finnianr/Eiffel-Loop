note
	description: "Summary description for {EL_DO_NOTHING__INSTALLER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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