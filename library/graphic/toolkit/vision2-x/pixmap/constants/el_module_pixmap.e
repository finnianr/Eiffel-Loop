note
	description: "Shared instance of class [$source EV_STOCK_PIXMAPS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 17:21:15 GMT (Tuesday 2nd March 2021)"
	revision: "13"

deferred class
	EL_MODULE_PIXMAP

inherit
	EL_MODULE

feature {NONE} -- Constants

	Pixmap: EL_STOCK_PIXMAPS
			--
		once
			create Result
		end

end