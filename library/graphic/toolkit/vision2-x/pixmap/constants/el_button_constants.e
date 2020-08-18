note
	description: "Button constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-18 19:36:10 GMT (Tuesday 18th August 2020)"
	revision: "1"

deferred class
	EL_BUTTON_CONSTANTS

inherit
	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Button_state: TUPLE [depressed, highlighted, normal: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "depressed, highlighted, normal")
		end

	Button_state_list: EL_ZSTRING_LIST
		once
			create Result.make_from_tuple (Button_state)
		end

end
