note
	description: "Module args"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_MODULE_ARGS

inherit
	EL_MODULE

feature -- Access

	Args: EL_COMMAND_LINE_ARGUMENTS
			--
		once
			create Result
		end

end
