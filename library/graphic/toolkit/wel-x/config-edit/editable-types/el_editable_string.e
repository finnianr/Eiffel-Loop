note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:13 GMT (Tuesday 2nd September 2014)"
	revision: "2"

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

