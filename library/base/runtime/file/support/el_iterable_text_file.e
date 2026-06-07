note
	description: "[
		Work around for the fact that the type signature of ${FILE}.new_cursor clashes with
		the implemenation of ${ITERABLE [STRING]} in ${EL_PLAIN_TEXT_FILE}.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_ITERABLE_TEXT_FILE

inherit
	ITERABLE [STRING]

create
	make

feature {NONE} -- Initialization

	make (a_file: like file)
		do
			file := a_file
		end

feature -- Factory

	new_cursor: EL_TEXT_FILE_LINE_CURSOR
		do
			create Result.make (file)
		end

feature {NONE} -- Internal attributes

	file: EL_PLAIN_TEXT_FILE

end
