note
	description: "Summary description for {NOTE_FIELD_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 15:59:35 GMT (Thursday 12th October 2017)"
	revision: "1"

class
	NOTE_FIELD_LIST

inherit
	EL_ARRAYED_LIST [NOTE_FIELD]

create
	make

feature -- Basic operations

	find (name: STRING)
		do
			find_first (name, agent {like item}.name)
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
