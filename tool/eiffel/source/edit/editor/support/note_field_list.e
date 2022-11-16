note
	description: "Note field list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	NOTE_FIELD_LIST

inherit
	EL_ARRAYED_LIST [NOTE_FIELD]

create
	make

feature -- Basic operations

	find (name: STRING)
		do
			find_first_equal (name, agent {like item}.name)
		end

feature -- Element change

	set_field (name: STRING; text: ZSTRING)
		do
			find (name)
			if found then
				item.set_text (text)
			else
				extend (create {like item}.make (name, text))
			end
		end
end