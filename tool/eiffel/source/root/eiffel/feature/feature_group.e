note
	description: "Group of class features with common export status"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-12 12:25:47 GMT (Thursday 12th September 2024)"
	revision: "11"

class
	FEATURE_GROUP

create
	make

feature {NONE} -- Initialization

	make (a_header: EDITABLE_SOURCE_LINES)
		local
			comments: LIST [ZSTRING]; pos_comment: INTEGER
		do
			header := a_header
			create features.make (5)

			comments := header.query_if (agent has_comment)
			if comments.is_empty then
				create name.make_empty
			else
				pos_comment := comments.first.substring_index (Comment_marks, 1)
				name := comments.first.substring_end (pos_comment + 2)
				name.adjust
			end
		end

feature -- Access

	features: EL_ARRAYED_LIST [CLASS_FEATURE]

	header: EDITABLE_SOURCE_LINES

	name: ZSTRING

	string_count: INTEGER
		do
			Result := features.sum_integer (agent {CLASS_FEATURE}.string_count)
		end

feature -- Element change

	append (line: ZSTRING)
		do
			features.last.lines.extend (line)
		end

feature {NONE} -- Implementation

	has_comment (line: ZSTRING): BOOLEAN
		do
			Result := line.has_substring (Comment_marks)
		end

feature {NONE} -- Constants

	Comment_marks: ZSTRING
		once
			Result := "--"
		end

end