note
	description: "Stock cursor pixmaps with workaround for Unix mis-assignment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_STOCK_PIXMAPS

inherit
	EV_STOCK_PIXMAPS
		redefine
			Sizeall_cursor
		end

	EL_SOLITARY
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			default_create
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