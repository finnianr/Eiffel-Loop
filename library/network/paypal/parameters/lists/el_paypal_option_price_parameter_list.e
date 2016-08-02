note
	description: "Summary description for {EL_PAYPAL_OPTION_PRICE_VARIABLE_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 16:32:00 GMT (Sunday 20th December 2015)"
	revision: "1"

class
	EL_PAYPAL_OPTION_PRICE_PARAMETER_LIST

inherit
	EL_PAYPAL_PARAMETER_LIST

create
	make

feature {NONE} -- Constants

	Name_prefix: ZSTRING
		once
			Result := "L_OPTION?PRICE"
		end

end