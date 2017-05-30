note
	description: "Summary description for {EL_REQUIRED_COMMAND_ARGUMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-30 4:08:18 GMT (Tuesday 30th May 2017)"
	revision: "1"

class
	EL_REQUIRED_COMMAND_ARGUMENT

inherit
	EL_COMMAND_ARGUMENT
		redefine
			is_required
		end

create
	make

feature {NONE} -- Constants

	Is_required: BOOLEAN = True

end
