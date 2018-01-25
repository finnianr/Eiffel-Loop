note
	description: "Summary description for {EL_MODULE_ARGS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-28 10:47:32 GMT (Thursday 28th December 2017)"
	revision: "4"

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
