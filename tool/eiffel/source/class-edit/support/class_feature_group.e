note
	description: "Class feature group"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	CLASS_FEATURE_GROUP

create
	make

feature {NONE} -- Initialization

	make (first_line: ZSTRING)
		do
			create header.make (2)
			header.extend (first_line)
			create features.make (5)
		end

feature -- Access

	features: EL_SORTABLE_ARRAYED_LIST [CLASS_FEATURE]

	header: SOURCE_LINES

	name: ZSTRING
		local
			line: ZSTRING
		do
			header.find_first (True, agent {ZSTRING}.has_substring (Comment_marks))
			if header.exhausted then
				create Result.make_empty
			else
				line := header.item
				Result := line.substring_end (line.substring_index (Comment_marks, 1) + 3)
				Result.right_adjust
			end
		end

feature {NONE} -- Constants

	Comment_marks: ZSTRING
		once
			Result := "--"
		end

end
