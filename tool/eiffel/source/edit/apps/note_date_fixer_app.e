note
	description: "[
		Fixes note dates with too many spaces as a result of a bug. For example

			date: "2018-09-20 10:06:24 GMT (Thursday  20th  September  2018)"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-05 8:18:09 GMT (Saturday 5th October 2024)"
	revision: "5"

class
	NOTE_DATE_FIXER_APP

inherit
	NOTE_EDITOR_APP
		redefine
			command
		end

feature {NONE} -- Implementation

	command: NOTE_DATE_FIXER_COMMAND

end