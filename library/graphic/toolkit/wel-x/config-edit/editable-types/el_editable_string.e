note
	description: "Editable string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_EDITABLE_STRING

inherit
	EL_EDITABLE [STRING]

create
	make

feature -- Element change

	set_item (string: STRING)
			--
		do
			is_last_edit_valid := true
			item := string			
			edit_listener.on_change (Current)
		end

end