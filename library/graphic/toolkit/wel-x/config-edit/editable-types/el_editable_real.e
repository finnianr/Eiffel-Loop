note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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
