note
	description: "[
		Shared instance of class
		[https://www.eiffel.org/files/doc/static/17.05/libraries/vision2/ev_stock_pixmaps_chart.html EV_STOCK_PIXMAPS]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-28 15:11:37 GMT (Sunday 28th June 2020)"
	revision: "10"

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
