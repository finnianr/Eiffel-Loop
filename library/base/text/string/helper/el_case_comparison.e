note
	description: "Case comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-03 15:57:18 GMT (Sunday 3rd January 2021)"
	revision: "6"

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