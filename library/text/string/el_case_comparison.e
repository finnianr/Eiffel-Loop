note
	description: "Summary description for {EL_CASE_COMPARISON}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

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