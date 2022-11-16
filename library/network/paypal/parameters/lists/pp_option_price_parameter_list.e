note
	description: "[
		Buy-button create/update option. (Optional) The price associated with the n'th menu item.

			L_OPTIONnPRICEx
		
		It is a list of variables for each OPTIONnNAME, in which x is a digit between 0 and 9, inclusive
	]"
	notes: "Specifying a price means you cannot set a button variable to amount"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	PP_OPTION_PRICE_PARAMETER_LIST

inherit
	PP_NUMBERED_VARIABLE_PARAMETER_LIST

create
	make

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "L_OPTION%SPRICE%S"
		end

end