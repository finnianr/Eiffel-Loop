note
	description: "Summary description for {EL_COMMA_SEPARATED_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_COMMA_SEPARATED_FILE

create
	make

feature {NONE} -- Initialization

	make (file_path: EL_FILE_PATH)
			--
		local
			l_lines: EL_FILE_LINE_SOURCE
		do
			create lines.make
			create l_lines.make (file_path)
			l_lines.do_all (agent extend)
			l_lines.close
		end

feature -- Access

	lines: LINKED_LIST [ARRAYED_LIST [STRING]]

feature -- Element change

	extend (str: EL_ASTRING)
		local
			line: EL_COMMA_SEPARATED_LINE
			fields: like lines.item
		do
			create line.make (str)
			create fields.make (line.fields.count)
			fields.append (line.fields)
			lines.extend (fields)
		end
end