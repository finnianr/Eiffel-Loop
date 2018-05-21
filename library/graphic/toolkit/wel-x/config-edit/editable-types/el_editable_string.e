note
	description: "Editable string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:05 GMT (Saturday 19th May 2018)"
	revision: "3"

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
