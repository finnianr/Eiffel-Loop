note
	description: "Color constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

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