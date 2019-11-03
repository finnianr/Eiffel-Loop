note
	description: "[
		Fixes note dates with too many spaces as a result of a bug. For example

			date: "2018-09-20 10:06:24 GMT (Thursday  20th  September  2018)"
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
			create Result.make (license_notes)
		end

end
