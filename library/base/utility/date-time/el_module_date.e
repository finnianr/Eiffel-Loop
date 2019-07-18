note
	description: "Module date"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:54:30 GMT (Monday 1st July 2019)"
	revision: "7"

deferred class
	EL_MODULE_DATE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Date: EL_ENGLISH_DATE_TEXT
			--
		once
			create Result.make
		end

end
