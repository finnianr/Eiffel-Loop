note
	description: "Object that is capable of making mistakes or being wrong"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-14 10:40:42 GMT (Sunday 14th May 2023)"
	revision: "2"

class
	EL_FALLIBLE

feature -- Status query

	has_error: BOOLEAN
		do
			Result := attached internal_error_list
		end

feature -- Access

	error_list: EL_ARRAYED_LIST [EL_ERROR_DESCRIPTION]
		do
			if attached internal_error_list as list then
				Result := list
			else
				create Result.make_empty
				internal_error_list := Result
			end
		end

feature -- Element change

	put (error: EL_ERROR_DESCRIPTION)
		do
			error_list.extend (error)
		end

	put_error_message (message: READABLE_STRING_GENERAL)
		local
			error: EL_ERROR_DESCRIPTION
		do
			create error.make_default
			error.set_lines (message)
			put (error)
		end

	reset
		do
			internal_error_list := Void
		end

feature -- Basic operations

	print_errors (log: EL_LOGGABLE)
		do
			across error_list as list loop
				log.put_new_line
				list.item.print_to (log)
			end
		end

feature {NONE} -- Internal attributes

	internal_error_list: detachable EL_ARRAYED_LIST [EL_ERROR_DESCRIPTION] note option: transient attribute end
end