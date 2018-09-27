note
	description: "Remote call errors"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_REMOTE_CALL_ERRORS

feature -- Access

	error_code: INTEGER

	error_detail: STRING

feature -- Element change

	set_error (code: INTEGER)
			--
		do
			error_code := code
		end

	set_error_detail (detail: STRING)
			--
		do
			error_detail := detail
		end

feature -- Status query

	has_error: BOOLEAN
			--
		do
			Result := error_code > 0
		end

end