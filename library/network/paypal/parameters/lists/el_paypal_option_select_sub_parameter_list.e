note
	description: "Summary description for {EL_PAYPAL_OPTION_SELECT_VARIABLE_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_PAYPAL_OPTION_SELECT_SUB_PARAMETER_LIST

inherit
	EL_PAYPAL_PARAMETER_LIST

create
	make

feature {NONE} -- Constants

	Name_prefix: ZSTRING
		once
			Result := "L_OPTION?SELECT"
		end
end