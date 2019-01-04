note
	description: "Object that is localizeable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-03 15:25:32 GMT (Thursday 3rd January 2019)"
	revision: "1"

deferred class
	EL_LOCALIZEABLE

feature {NONE} -- Access

	language: STRING
		deferred
		ensure
			two_letter_code: Result.count = 2
		end
end
