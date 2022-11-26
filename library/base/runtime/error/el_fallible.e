note
	description: "Object that is capable of making mistakes or being wrong"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-26 7:57:32 GMT (Saturday 26th November 2022)"
	revision: "1"

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

	print_errors
		do
			error_list.do_all (agent {EL_ERROR_DESCRIPTION}.print_to_lio)
		end

feature {NONE} -- Internal attributes

	internal_error_list: detachable EL_ARRAYED_LIST [EL_ERROR_DESCRIPTION] note option: transient attribute end
end