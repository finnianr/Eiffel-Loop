note
	description: "Remote call errors"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 19:43:15 GMT (Monday 13th January 2020)"
	revision: "7"

deferred class
	EL_REMOTE_CALL_ERRORS

inherit
	EL_SHARED_EROS_ERROR

feature {NONE} -- Initialization

	make_default
		do
			create error_detail.make_empty
		end

feature -- Access

	error_code: NATURAL_8

	error_detail: STRING

feature -- Element change

	set_error (code: NATURAL_8)
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
