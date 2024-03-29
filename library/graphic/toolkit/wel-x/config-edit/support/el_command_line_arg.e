note
	description: "Command line arg"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

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