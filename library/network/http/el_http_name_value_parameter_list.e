note
	description: "Summary description for {EL_HTTP_PARAMETER_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_HTTP_NAME_VALUE_PARAMETER_LIST

inherit
	EL_HTTP_PARAMETER_LIST [EL_HTTP_NAME_VALUE_PARAMETER]

feature -- Element change

	extend_from_file (lines: EL_FILE_LINE_SOURCE)
			-- Append from line source of name value pairs
			-- <name>: <value>
			-- # symbol indicates comment line
		local
			pos_colon: INTEGER
			l_line, value: ASTRING
		do
			across lines as line loop
				l_line := line.item
				if l_line.count > 1 and then l_line [1] /= '#' then
					pos_colon := l_line.index_of (':', 1)
					if pos_colon > 1 then
						value := l_line.substring (pos_colon + 1, l_line.count)
						value.left_adjust
						extend (create {like item}.make (l_line.substring (1, pos_colon - 1), value))
					end
				end
			end
		end

end
