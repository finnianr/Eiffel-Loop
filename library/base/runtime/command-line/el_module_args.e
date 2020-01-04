note
	description: "Module args"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-30 17:47:40 GMT (Monday 30th December 2019)"
	revision: "11"

deferred class
	EL_MODULE_ARGS

inherit
	EL_MODULE

feature {NONE} -- Constants

	Args: EL_COMMAND_LINE_ARGUMENTS
			--
		once
			create Result.make
		end

end
