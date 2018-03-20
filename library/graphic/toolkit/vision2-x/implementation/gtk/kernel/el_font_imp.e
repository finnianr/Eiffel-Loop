note
	description: "[
		Unix counterpart to Windows [$source EL_FONT_IMP] which fixes a problem settting the height in pixels
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:10:02 GMT (Wednesday 21st February 2018)"
	revision: "3"

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
