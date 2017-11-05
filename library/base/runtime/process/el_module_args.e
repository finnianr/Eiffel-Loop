note
	description: "Summary description for {EL_MODULE_ARGS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-31 13:32:24 GMT (Tuesday 31st October 2017)"
	revision: "3"

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
