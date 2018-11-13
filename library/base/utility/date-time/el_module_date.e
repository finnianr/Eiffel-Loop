note
	description: "Module date"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:07:28 GMT (Monday 12th November 2018)"
	revision: "6"

class
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
