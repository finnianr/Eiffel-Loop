note
	description: "Summary description for {EL_COMMA_SEPARATED_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "4"

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

	extend (str: ASTRING)
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
