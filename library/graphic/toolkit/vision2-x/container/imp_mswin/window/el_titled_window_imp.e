note
	description: "Not so silly window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-03 11:32:07 GMT (Wednesday 3rd January 2024)"
	revision: "6"

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

	EL_SHARED_NATIVE_STRING

create
	make

feature -- Access

	current_theme_name: STRING_32
		do
			Native_string.set_empty_capacity ({EL_WEL_API}.max_path_count)
			if attached Native_string as name
				and then {EL_WEL_API}.get_current_theme_name (name.item, name.capacity) = 0
			then
				Result := name.to_string_32
			else
				create Result.make_empty
			end
		end

feature -- Status query

	has_wide_theme_border: BOOLEAN

		local
			theme_path: DIR_PATH
		do
			theme_path := current_theme_name
			Result := theme_path.has_step (Aero)
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_TITLED_WINDOW note option: stable attribute end;

feature {NONE} -- Constants

	Aero: ZSTRING
		once
			Result := "Aero"
		end
end