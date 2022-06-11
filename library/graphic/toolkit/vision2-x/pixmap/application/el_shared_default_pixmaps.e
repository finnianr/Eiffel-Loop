note
	description: "Default pixmaps for descendants of [$source EV_WINDOW]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-11 14:41:39 GMT (Saturday 11th June 2022)"
	revision: "1"

deferred class
	EL_SHARED_DEFAULT_PIXMAPS

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	pixmaps: EL_STOCK_PIXMAPS
		do
			Result := Default_pixmaps
		end

feature {NONE} -- Constants

	Default_pixmaps: EL_STOCK_PIXMAPS
		once ("PROCESS")
			Result := create {EL_SINGLETON_OR_DEFAULT [EL_STOCK_PIXMAPS, EL_STOCK_PIXMAPS]}
		end
end