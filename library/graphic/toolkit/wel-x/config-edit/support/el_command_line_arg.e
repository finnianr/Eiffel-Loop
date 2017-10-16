note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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
