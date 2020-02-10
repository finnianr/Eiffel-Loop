note
	description: "Shared access to routines of class [$source EL_UTF_CONVERTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-10 15:33:58 GMT (Monday 10th February 2020)"
	revision: "10"

deferred class
	EL_MODULE_UTF

inherit
	EL_MODULE

feature {NONE} -- Constants

	UTF: EL_UTF_CONVERTER
		once
			create Result
		end

end
