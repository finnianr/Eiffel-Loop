note
	description: "Summary description for {EL_CASE_COMPARISON}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 10:24:30 GMT (Sunday 28th July 2013)"
	revision: "2"

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