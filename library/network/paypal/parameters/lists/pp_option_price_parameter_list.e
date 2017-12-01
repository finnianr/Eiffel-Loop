note
	description: "Summary description for {PP_OPTION_PRICE_VARIABLE_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-23 14:46:09 GMT (Thursday 23rd November 2017)"
	revision: "3"

class
	PP_OPTION_PRICE_PARAMETER_LIST

inherit
	PP_PARAMETER_LIST

create
	make

feature {NONE} -- Constants

	Name_prefix: ZSTRING
		once
			Result := "L_OPTION?PRICE"
		end

end
