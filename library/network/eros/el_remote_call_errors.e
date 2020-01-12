note
	description: "Remote call errors"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-11 17:14:24 GMT (Saturday 11th January 2020)"
	revision: "6"

class
	EL_REMOTE_CALL_ERRORS

feature {NONE} -- Initialization

	make
		do
			create error_detail.make_empty
		end

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
