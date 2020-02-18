note
	description: "Log filter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 13:11:42 GMT (Tuesday 18th February 2020)"
	revision: "7"

class
	EL_LOG_FILTER

create
	make

feature {NONE} -- Initialization

	make (a_class_type: like class_type; a_routines: STRING)
		local
			routine_list: LIST [STRING]
		do
			class_type := a_class_type
			routine_list := a_routines.split (',')
			create routines.make (1, routine_list.count)
			across routine_list as name loop
				name.item.left_adjust
				routines [name.cursor_index] := name.item
			end
		end

feature -- Access

	class_type: TYPE [EL_MODULE_LIO]

	routines: ARRAY [STRING]

end
