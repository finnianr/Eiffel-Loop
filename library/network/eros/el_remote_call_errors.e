note
	description: "Summary description for {EL_REMOTE_CALL_ERRORS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

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
