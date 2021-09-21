note
	description: "Key enumeration accessible from [$source EL_SHARED_KEY_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-21 12:41:37 GMT (Tuesday 21st September 2021)"
	revision: "2"

class
	EL_KEY_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			export_name as to_kebab_case_lower,
			import_name as from_snake_case_lower
		redefine
			initialize_fields
		end

	EL_MODULE_DEFERRED_LOCALE

create
	make

feature {NONE} -- Initialization

	initialize_fields
		local
			ev: EV_KEY_CONSTANTS
		do
			create ev
			key_alt := ev.Key_alt.to_natural_8
			key_back_space := ev.Key_back_space.to_natural_8
			key_backquote := ev.Key_backquote.to_natural_8
			key_backslash := ev.Key_backslash.to_natural_8
			key_caps_lock := ev.Key_caps_lock.to_natural_8
			key_close_bracket := ev.Key_close_bracket.to_natural_8
			key_comma := ev.Key_comma.to_natural_8
			key_ctrl := ev.Key_ctrl.to_natural_8
			key_dash := ev.Key_dash.to_natural_8
			key_delete := ev.Key_delete.to_natural_8
			key_down := ev.Key_down.to_natural_8
			key_end := ev.Key_end.to_natural_8
			key_enter := ev.Key_enter.to_natural_8
			key_equal := ev.Key_equal.to_natural_8
			key_escape := ev.Key_escape.to_natural_8

			key_home := ev.Key_home.to_natural_8
			key_insert := ev.Key_insert.to_natural_8
			key_left := ev.Key_left.to_natural_8
			key_left_meta := ev.Key_left_meta.to_natural_8
			key_menu := ev.Key_menu.to_natural_8
			key_num_lock := ev.Key_num_lock.to_natural_8

			key_open_bracket := ev.Key_open_bracket.to_natural_8
			key_page_down := ev.Key_page_down.to_natural_8
			key_page_up := ev.Key_page_up.to_natural_8
			key_pause := ev.Key_pause.to_natural_8
			key_period := ev.Key_period.to_natural_8
			key_quote := ev.Key_quote.to_natural_8
			key_right := ev.Key_right.to_natural_8
			key_right_meta := ev.Key_right_meta.to_natural_8
			key_scroll_lock := ev.Key_scroll_lock.to_natural_8
			key_semicolon := ev.Key_semicolon.to_natural_8
			key_shift := ev.Key_shift.to_natural_8

			key_slash := ev.Key_slash.to_natural_8
			key_space := ev.Key_space.to_natural_8
			key_tab := ev.Key_tab.to_natural_8
			key_up := ev.Key_up.to_natural_8
		end

feature -- Access

	locale_key (key: NATURAL_8): ZSTRING
		do
			Result := name (key.to_natural_8)
			Result.enclose ('{', '}')
		end

	locale_name (key: INTEGER): ZSTRING
		do
			Result := Locale * locale_key (key.to_natural_8)
		end

feature -- Contract Support

	valid_locale_keys: BOOLEAN
--		local
--			key: ZSTRING
		do
			Result := across list as n all Locale.has_key (locale_key (n.item)) end
--			Result := True
--			across list as n until not Result loop
--				key := locale_key (n.item)
--				Result := Locale.has_key (key)
--			end
		end

feature -- Values

	key_alt: NATURAL_8

	key_back_space: NATURAL_8

	key_backquote: NATURAL_8

	key_backslash: NATURAL_8

	key_caps_lock: NATURAL_8

	key_close_bracket: NATURAL_8

	key_comma: NATURAL_8

	key_ctrl: NATURAL_8

	key_dash: NATURAL_8

	key_delete: NATURAL_8

	key_down: NATURAL_8

	key_end: NATURAL_8

	key_enter: NATURAL_8

	key_equal: NATURAL_8

	key_escape: NATURAL_8

	key_home: NATURAL_8

	key_insert: NATURAL_8

	key_left: NATURAL_8

	key_left_meta: NATURAL_8

	key_menu: NATURAL_8

	key_num_lock: NATURAL_8

	key_open_bracket: NATURAL_8

	key_page_down: NATURAL_8

	key_page_up: NATURAL_8

	key_pause: NATURAL_8

	key_period: NATURAL_8

	key_quote: NATURAL_8

	key_right: NATURAL_8

	key_right_meta: NATURAL_8

	key_scroll_lock: NATURAL_8

	key_semicolon: NATURAL_8

	key_shift: NATURAL_8

	key_slash: NATURAL_8

	key_space: NATURAL_8

	key_tab: NATURAL_8

	key_up: NATURAL_8

end