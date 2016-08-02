note
	description: "Summary description for {EL_CLASS_FEATURE_BLOCK}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 11:35:46 GMT (Friday 18th December 2015)"
	revision: "1"

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

	header: EIFFEL_SOURCE_LINES

	name: ZSTRING
		local
			line: ZSTRING
		do
			header.find_first (True, agent {ZSTRING}.has_substring (Comment_marks))
			if header.exhausted then
				create Result.make_empty
			else
				line := header.item
				Result := line.substring (line.substring_index (Comment_marks, 1) + 3, line.count)
				Result.right_adjust
			end
		end

feature {NONE} -- Constants

	Comment_marks: ZSTRING
		once
			Result := "--"
		end

end