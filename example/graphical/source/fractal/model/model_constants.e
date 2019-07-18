note
	description: "Color constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:02:19 GMT (Monday 1st July 2019)"
	revision: "5"

deferred class
	MODEL_CONSTANTS

inherit
	EL_MODULE_COLOR

feature {NONE} -- Constants

	Color_placeholder: EV_COLOR
		once
			Result := Color.new_html ("#E0E0E0")
		end

	Color_skirt: EV_COLOR
		once
			Result := Color.new_html ("#0099A4")
		end

end
