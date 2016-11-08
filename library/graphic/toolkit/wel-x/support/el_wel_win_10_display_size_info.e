note
	description: "Display size for Windows major_version >= 10"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-09 17:18:57 GMT (Sunday 9th October 2016)"
	revision: "1"

class
	EL_WEL_WIN_10_DISPLAY_SIZE_INFO

inherit
	EL_WEL_DISPLAY_SIZE_INFO
		redefine
			default_create
		end

	WEL_UNIT_CONVERSION
		undefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		local
			dc: WEL_SCREEN_DC
		do
			create dc; dc.get
			height_centimeters := (get_device_caps (dc.item, Vertical_size) / 10).truncated_to_real
			width_centimeters := (get_device_caps (dc.item, Horizontal_size) / 10).truncated_to_real
			dc.release
		end

end
