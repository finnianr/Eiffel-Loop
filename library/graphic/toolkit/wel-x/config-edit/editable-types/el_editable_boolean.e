note
	description: "Editable boolean"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:05 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_EDITABLE_BOOLEAN

inherit
	EL_EDITABLE [BOOLEAN]

create
	make

feature -- Element change

	set_item (string: STRING)
			--
		do
			is_last_edit_valid := string.is_boolean
			if is_last_edit_valid then
				item := string.to_boolean
				edit_listener.on_change (Current)
			end
		end

end
