note
	description: "Note field list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-08 15:26:12 GMT (Sunday 8th September 2024)"
	revision: "6"

class
	NOTE_FIELD_LIST

inherit
	EL_ARRAYED_LIST [NOTE_FIELD]

create
	make

feature -- Basic operations

	find (name: IMMUTABLE_STRING_8)
		do
			find_first_equal (name, agent {like item}.name)
		end

feature -- Element change

	set_field (name: IMMUTABLE_STRING_8; text: ZSTRING)
		do
			find (name)
			if found then
				item.set_text (text)
			else
				extend (create {like item}.make (name, text))
			end
		end
end