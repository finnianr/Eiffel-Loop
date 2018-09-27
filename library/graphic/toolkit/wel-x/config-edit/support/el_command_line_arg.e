note
	description: "Command line arg"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_COMMAND_LINE_ARG
	
create
	make

feature {NONE} -- Initialization

	make (a_template: STRING; a_value: EL_EDITABLE_VALUE)
			--
		do
			info_template := a_template
			value := a_value
		end

feature -- Access

	info: STRING
			--
		do
			create Result.make_from_string (info_template)
			Result.replace_substring_all ("$VALUE", value.out )
		end

feature {NONE} -- Implementation

	info_template: STRING
	
	value: EL_EDITABLE_VALUE
	
end
