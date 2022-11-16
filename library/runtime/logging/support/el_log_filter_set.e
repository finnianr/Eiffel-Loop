note
	description: "Log filter set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_LOG_FILTER_SET [TYPE_LIST -> TUPLE create default_create end]

inherit
	HASH_TABLE [EL_LOG_FILTER, TYPE [EL_MODULE_LIO]]
		rename
			make as make_with_count
		export
			{NONE} all
			{ANY} linear_representation
		end

	EL_LOG_CONSTANTS
		rename
			Show_all as Type_show_all,
			Show_none as Type_show_none,
			Show_selected as Type_show_selected
		end

create
	make, make_empty, make_with_count

feature {NONE} -- Initialization

	make
		do
			make_with_count (type_list.count)
			across type_list as type loop
				put (create {EL_LOG_FILTER}.make (type.item, Type_show_all), type.item)
			end
		end

	make_empty
		do
			make_with_count (0)
		end

feature -- Access

	type_list: EL_TUPLE_TYPE_LIST [EL_MODULE_LIO]
		do
			create Result.make_from_tuple (create {TYPE_LIST})
		end

feature -- Status setting

	hide_all (class_type: like type_list.item)
		-- hide output of all routines of `class_type'
		do
			put (create {EL_LOG_FILTER}.make (class_type, Type_show_none), class_type)
		end

	show_all (class_type: like type_list.item)
		-- show output for all routines of `class_type'
		do
			put (create {EL_LOG_FILTER}.make (class_type, Type_show_all), class_type)
		end

	show_selected (class_type: like type_list.item; routines_list: STRING)
		-- show output only for selected routines of `class_type' in comma separated `routines_list'
		do
			put (create {EL_LOG_FILTER}.make_selected (class_type, routines_list), class_type)
		end

end