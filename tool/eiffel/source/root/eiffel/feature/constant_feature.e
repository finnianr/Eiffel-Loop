note
	description: "[
		Features that do not require any expansion like for example
		
			Pi: REAL = 3.142
			
			Name: STRING = "[
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-06 11:50:13 GMT (Thursday 6th April 2023)"
	revision: "3"

class
	CONSTANT_FEATURE

inherit
	CLASS_FEATURE
		redefine
			adjust_manifest_tuple_tabs
		end

create
	make

feature -- Element change

	adjust_manifest_tuple_tabs
		do
		end

	expand_shorthand
		do
		end

end