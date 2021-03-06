note
	description: "Editable real"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_EDITABLE_REAL

inherit
	EL_EDITABLE [REAL]

create
	make

feature -- Element change

	set_item (string: STRING)
			--
		do
			is_last_edit_valid := string.is_real
			if is_last_edit_valid then
				item := string.to_real
				edit_listener.on_change (Current)
			end
		end

end
