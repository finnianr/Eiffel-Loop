note
	description: "[
		Unix counterpart to Windows [$source EL_FONT_IMP] which fixes a problem settting the height in pixels
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_FONT_IMP

inherit
	EL_FONT_I
		undefine
			set_values, string_size
		redefine
			interface
		end

	EV_FONT_IMP
		redefine
			interface
		end

create
	make

feature {NONE} -- Implementation

	interface: detachable EL_FONT note option: stable attribute end;

end