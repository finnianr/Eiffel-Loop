note
	description: "Object that is localizeable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-25 12:00:46 GMT (Saturday 25th September 2021)"
	revision: "2"

deferred class
	EL_LOCALIZEABLE

feature {NONE} -- Access

	language: STRING
		deferred
		ensure
			two_letter_code: Result.count = 2
		end
end