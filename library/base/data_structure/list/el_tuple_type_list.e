note
	description: "List of tuple element types conforming to generic type `T'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-09-28 14:57:32 GMT (Wednesday 28th September 2022)"
	revision: "10"

class
	EL_TUPLE_TYPE_LIST [T]

inherit
	EL_ARRAYED_LIST [TYPE [T]]
		rename
			make as make_list,
			make_from_tuple as make_list_from_tuple
		redefine
			make_from_array
		end

create
	make, make_from_static, make_from_tuple, make_from_array

feature {NONE} -- Initialization

	make (type_array: EL_TUPLE_TYPE_ARRAY)
		do
			make_list (type_array.count)
			compare_objects
			non_conforming_list := Empty_list
			across type_array as type loop
				-- skip non-conforming types
				if attached {like item} type.item as l_type then
					extend (l_type)
				elseif not all_conform then
					non_conforming_list.extend (type.item)
				else
					create non_conforming_list.make (1)
					non_conforming_list.extend (type.item)
				end
			end
		end

	make_from_array (a: ARRAY [TYPE [T]])
		do
			Precursor (a)
			compare_objects
			non_conforming_list := Empty_list
		end

	make_from_static (static_type: INTEGER)
		do
			make (create {EL_TUPLE_TYPE_ARRAY}.make_from_static (static_type))
		end

	make_from_tuple (tuple: TUPLE)
		do
			make (create {EL_TUPLE_TYPE_ARRAY}.make_from_tuple (tuple))
		end

feature -- Access

	non_conforming_list: like Empty_list
		-- items in `type_array' argument to `make' routine that do not conform to type `T'

feature -- Status query

	all_conform: BOOLEAN
		-- `True' if all items in `make' routine argument `type_array' conform to type `T'
		do
			Result := non_conforming_list = Empty_list
		end

feature -- Basic operations

	log_error (lio: EL_LOGGABLE; message: READABLE_STRING_GENERAL)
		local
			text: STRING
		do
			lio.put_line (message)
			text := "does not conform to type " + ({T}).name
			across non_conforming_list as non_conforming loop
				lio.put_labeled_substitution (non_conforming.item.name, text)
				lio.put_new_line
			end
		end

feature {NONE} -- Constants

	Empty_list: ARRAYED_LIST [TYPE [ANY]]
		once
			create Result.make (0)
		end
end