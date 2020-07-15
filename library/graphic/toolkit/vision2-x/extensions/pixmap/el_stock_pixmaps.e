note
	description: "Stock cursor pixmaps with workaround for Unix mis-assignment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-15 13:19:38 GMT (Wednesday 15th July 2020)"
	revision: "1"

class
	EL_STOCK_PIXMAPS

inherit
	EV_STOCK_PIXMAPS
		redefine
			Sizeall_cursor
		end

feature -- Constants

	Sizeall_cursor: EV_POINTER_STYLE
		once
			if {PLATFORM}.is_unix then
				-- Work around for bug
				Result := Sizenwse_cursor
			else
				Result := Precursor
			end
		end

end
