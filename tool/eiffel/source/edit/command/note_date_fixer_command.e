note
	description: "[
		Fixes note dates with too many spaces as a result of a bug. For example

			date: "2018-09-20 10:06:24 GMT (Thursday  20th  September  2018)"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 10:06:24 GMT (Thursday 20th September 2018)"
	revision: "7"

class
	NOTE_DATE_FIXER_COMMAND

inherit
	NOTE_EDITOR_COMMAND
		redefine
			new_editor
		end

create
	make

feature {NONE} -- Implementation

	new_editor: DATE_NOTE_EDITOR
		do
			create Result.make (manifest.notes, Current)
		end

end