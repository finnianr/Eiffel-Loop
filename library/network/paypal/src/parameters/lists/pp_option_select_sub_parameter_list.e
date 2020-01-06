note
	description: "[
		Buy-button create/update option. (Optional) The menu item's name.
		
			L_OPTIONnSELECTx
			
		It is a list of variables for each OPTIONnNAME, in which x is a digit between 0 and 9, inclusive
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	PP_OPTION_SELECT_SUB_PARAMETER_LIST

inherit
	PP_NUMBERED_VARIABLE_PARAMETER_LIST

create
	make

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "L_OPTION%SSELECT%S"
		end
end
