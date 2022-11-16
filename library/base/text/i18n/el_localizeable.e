note
	description: "Object that is localizeable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	EL_LOCALIZEABLE

feature {NONE} -- Access

	language: STRING
		deferred
		ensure
			two_letter_code: Result.count = 2
		end
end