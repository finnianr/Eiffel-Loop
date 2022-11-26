note
	description: "Error description"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-26 7:12:43 GMT (Saturday 26th November 2022)"
	revision: "1"

class
	EL_ERROR_DESCRIPTION

inherit
	EL_ZSTRING_LIST
		rename
			make as make_list
		export
			{NONE} all
			{ANY} append, append_sequence, extend, is_empty, count, first
		end

	EL_MODULE_LIO

	EL_STRING_8_CONSTANTS

create
	make, make_default

feature {NONE} -- Initialization

	make (a_id: like id)
		do
			make_default
			id := a_id
		end

	make_default
		do
			id := Empty_string_8
			make_empty
		end

feature -- Access

	id: READABLE_STRING_GENERAL

feature -- Element change

	set_lines (a_string: READABLE_STRING_GENERAL)
		do
			make_with_lines (a_string)
		end

	set_id (a_id: like id)
		do
			id := a_id
		end

feature -- Basic operations

	print_to_lio
		do
			lio.put_new_line
			across Current as line loop
				lio.put_line (line.item)
			end
		end

end