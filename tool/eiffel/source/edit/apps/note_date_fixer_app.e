note
	description: "[
		Fixes note dates with too many spaces as a result of a bug. For example

			date: "2018-09-20 10:06:24 GMT (Thursday  20th  September  2018)"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	NOTE_DATE_FIXER_APP

inherit
	NOTE_EDITOR_APP
		redefine
			command, Option_name
		end

feature {NONE} -- Implementation

	command: NOTE_DATE_FIXER_COMMAND

feature {NONE} -- Constants

	Option_name: STRING
		once
			Result := "date_fixer"
		end

end