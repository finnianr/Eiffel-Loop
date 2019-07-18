note
	description: "[
		Shared instance of class
		[https://www.eiffel.org/files/doc/static/18.11/libraries/vision2/ev_stock_colors_chart.html EV_STOCK_COLORS]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:24:02 GMT (Monday 1st July 2019)"
	revision: "10"

deferred class
	EL_MODULE_COLOR

inherit
	EL_MODULE

feature {NONE} -- Constants

	Color: EL_STOCK_COLORS
			--
		once
			create Result
		end

end
