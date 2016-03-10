note
	description: "Summary description for {EL_LOG_FILTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_LOG_FILTER

create
	make

feature {NONE} -- Initialization

	make (a_class_type: TYPE [EL_MODULE_LOG]; a_routines: STRING)
		local
			routine_list: LIST [STRING]
		do
			type := a_class_type
			routine_list := a_routines.split (',')
			create routines.make (1, routine_list.count)
			across routine_list as name loop
				name.item.left_adjust
				routines [name.cursor_index] := name.item
			end
		end

feature -- Access

	type: TYPE [EL_MODULE_LOG]

	routines: ARRAY [STRING]

end
