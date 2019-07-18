note
	description: "[
		Shared instance of class
		[https://www.eiffel.org/files/doc/static/17.05/libraries/vision2/ev_stock_pixmaps_chart.html EV_STOCK_PIXMAPS]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:22:58 GMT (Monday 1st July 2019)"
	revision: "9"

deferred class
	EL_MODULE_PIXMAP

inherit
	EL_MODULE

feature {NONE} -- Constants

	Pixmap: EV_STOCK_PIXMAPS
			--
		once
			create Result
		end

end
