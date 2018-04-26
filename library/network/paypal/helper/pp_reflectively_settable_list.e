note
	description: "List of objects conforming to [$source PP_REFLECTIVELY_SETTABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-16 19:09:44 GMT (Saturday 16th December 2017)"
	revision: "1"

class
	PP_REFLECTIVELY_SETTABLE_LIST [G -> PP_REFLECTIVELY_SETTABLE create make_default end]

inherit
	EL_ARRAYED_LIST [G]

	EL_MAKEABLE
		rename
			make as make_empty
		undefine
			is_equal, copy
		end

create
	make

feature -- Element change

	set_i_th (var: PP_VARIABLE; a_value: ZSTRING)
		do
			if valid_index (var.index) then
				go_i_th (var.index)
			else
				extend (create {G}.make_default)
				finish
			end
			item.set_field (var.name, a_value)
		end
end
