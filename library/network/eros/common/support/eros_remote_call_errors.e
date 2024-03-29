note
	description: "Remote call errors"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "10"

deferred class
	EROS_REMOTE_CALL_ERRORS

inherit
	EROS_SHARED_ERROR

feature {NONE} -- Initialization

	make_default
		do
			create error_detail.make_empty
		end

feature -- Access

	error_code: NATURAL_8

	error_detail: STRING

feature -- Element change

	set_error (code: NATURAL_8; detail: STRING)
			--
		do
			error_code := code
			error_detail.share (detail)
		end

	reset_errors
		do
			error_code := 0
			error_detail.wipe_out
		end

feature -- Status query

	has_error: BOOLEAN
			--
		do
			Result := error_code > 0
		end

end