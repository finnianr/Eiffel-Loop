note
	description: "Markup line counter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	MARKUP_LINE_COUNTER

feature -- Measurement

	line_ends_with_count (a_file_path: EL_FILE_PATH; tag: ZSTRING): INTEGER
			-- Build object from xml file
		local
			lines: EL_FILE_LINE_SOURCE
		do
			create lines.make (a_file_path)
			from lines.start until lines.after loop
				if lines.item.ends_with (tag) then
					Result := Result + 1
				end
				lines.forth
			end
		end

end