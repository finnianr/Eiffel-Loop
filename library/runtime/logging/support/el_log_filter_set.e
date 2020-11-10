note
	description: "Log filter set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-10 10:18:04 GMT (Tuesday 10th November 2020)"
	revision: "3"

class
	EL_LOG_FILTER_SET [TYPE_LIST -> TUPLE create default_create end]

inherit
	HASH_TABLE [EL_LOG_FILTER, TYPE [EL_MODULE_LOG]]
		rename
			make as make_with_count,
			linear_representation as as_list
		export
			{NONE} all
			{ANY} as_list
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
		local
			type_list: EL_TUPLE_TYPE_LIST [EL_MODULE_LOG]
			filter: EL_LOG_FILTER
		do
			create type_list.make_from_tuple (create {TYPE_LIST})
			make_with_count (type_list.count)
			across type_list as type loop
				create filter.make (type.item, Type_show_all)
				put (filter, type.item)
			end
		end

	make_empty
		do
			make_with_count (0)
		end

feature -- Status setting

	hide_all (class_type: TYPE [EL_MODULE_LOG])
		-- hide output of all routines of `class_type'
		do
			put (create {EL_LOG_FILTER}.make (class_type, Type_show_none), class_type)
		end

	show_all (class_type: TYPE [EL_MODULE_LOG])
		-- show output for all routines of `class_type'
		do
			put (create {EL_LOG_FILTER}.make (class_type, Type_show_all), class_type)
		end

	show_selected (class_type: TYPE [EL_MODULE_LOG]; routines_list: STRING)
		-- show output only for selected routines of `class_type' in comma separated `routines_list'
		do
			put (create {EL_LOG_FILTER}.make_selected (class_type, routines_list), class_type)
		end

end