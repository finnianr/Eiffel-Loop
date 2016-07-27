note
	description: "Not so silly window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-30 17:40:05 GMT (Wednesday 30th March 2016)"
	revision: "5"

class
	EL_TITLED_WINDOW_IMP

inherit
	EL_TITLED_WINDOW_I
		undefine
			propagate_foreground_color, propagate_background_color, lock_update, unlock_update
		redefine
			interface
		end

	EV_TITLED_WINDOW_IMP
		redefine
			interface
		end

create
	make

feature -- Access

	current_theme_name: STRING_32
		local
			name: NATIVE_STRING
		do
			create name.make_empty ({EL_WEL_API}.max_path)
			if {EL_WEL_API}.get_current_theme_name (name.item, name.capacity) = 0 then
				Result := name.string
			else
				create Result.make_empty
			end
		end

feature -- Status query

	has_wide_theme_border: BOOLEAN

		local
			theme_path: EL_PATH_STEPS
		do
			theme_path := current_theme_name
			Result := theme_path.has (Aero)
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_TITLED_WINDOW note option: stable attribute end;

feature {NONE} -- Constants

	Aero: ZSTRING
		once
			Result := "Aero"
		end
end