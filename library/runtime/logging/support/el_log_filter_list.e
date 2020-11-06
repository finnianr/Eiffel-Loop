note
	description: "Log filter list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-05 18:35:53 GMT (Thursday 5th November 2020)"
	revision: "1"

class
	EL_LOG_FILTER_LIST [TYPE_LIST -> TUPLE create default_create end]

inherit
	ARRAYED_LIST [EL_LOG_FILTER]
		rename
			make as make_with_count,
			extend as extend_list
		export
			{NONE} all
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
				create filter.make (type.item, All_routines)
				extend_list (filter)
			end
		ensure
			no_duplicates: logged_type_set.count = count
		end

	make_empty
		do
			make_with_count (0)
		end

feature -- Status setting

	hide_all_routines (class_type: TYPE [EL_MODULE_LOG])
		do
			show_routines (class_type, No_routines)
		end

	show_all_routines (class_type: TYPE [EL_MODULE_LOG])
		do
			show_routines (class_type, All_routines)
		end

	show_routines (class_type: TYPE [EL_MODULE_LOG]; routines_list: STRING)
		-- log only routines in comma separated list `routines_list'
		local
			filter: EL_LOG_FILTER; found: BOOLEAN
		do
			create filter.make (class_type, routines_list)
			from start until found or after loop
				if item.class_type ~ class_type then
					found := True
				else
					forth
				end
			end
			if found then
				replace (filter)
			else
				extend_list (filter)
			end
		end

feature {NONE} -- Contract Support

	logged_type_set: EL_HASH_SET [INTEGER]
		do
			create Result.make (count)
			across Current as filter loop
				Result.put (filter.item.class_type.type_id)
			end
		end

feature {NONE} -- Constants

	All_routines: STRING = "*"

	No_routines: STRING = "-*"

end