note
	description: "[
		Shared instance of class
		[https://www.eiffel.org/files/doc/static/18.11/libraries/vision2/ev_stock_colors_chart.html EV_STOCK_COLORS]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-11 12:57:42 GMT (Friday 11th September 2020)"
	revision: "12"

deferred class
	EL_MODULE_COLOR

inherit
	EL_MODULE

feature {NONE} -- Constants

	Color: EL_STOCK_COLORS_I
			--
		once
			create {EL_STOCK_COLORS_IMP} Result
		end

end
