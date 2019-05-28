note
	description: "Color constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-27 14:41:27 GMT (Monday 27th May 2019)"
	revision: "1"

class
	COLOR_CONSTANTS

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
