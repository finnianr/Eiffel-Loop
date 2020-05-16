note
	description: "Shared access to instance of [$source EL_FIND_FILE_FILTER_FACTORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-16 12:26:01 GMT (Saturday 16th May 2020)"
	revision: "1"

deferred class
	EL_SHARED_FIND_FILE_FILTER_FACTORY

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Filter: EL_FIND_FILE_FILTER_FACTORY
		once
			create Result
		end
end
