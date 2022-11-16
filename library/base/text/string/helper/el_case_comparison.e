note
	description: "Case comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_CASE_COMPARISON

feature -- Status Change

	disable_case_sensitive
		do
			is_case_sensitive := False
		end

	enable_case_sensitive
		do
			is_case_sensitive := True
		end

feature -- Status Query

	is_case_sensitive: BOOLEAN

end