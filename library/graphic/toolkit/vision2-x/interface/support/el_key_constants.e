note
	description: "[
		Copy of `Key_strings' from class
		[https://www.eiffel.org/files/doc/static/17.01/libraries/vision2/ev_key_constants_chart.html EV_KEY_CONSTANTS]
		for use in sub-application: [$source EL_CHECK_LOCALE_STRINGS_APP].
		These localized names are referenced in class [$source EL_MENU]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:12:20 GMT (Wednesday 21st February 2018)"
	revision: "3"

class
	EL_KEY_CONSTANTS

inherit
	EL_MODULE_DEFERRED_LOCALE

	EV_KEY_CONSTANTS
		rename
			Key_strings as Key_strings_32
		end

feature -- Access

	Key_strings: ARRAY [ZSTRING]
			-- String representations of all key codes.
		once
			create Result.make_filled ("}", Key_0, Key_menu)
			Result.put (Locale * "{key-NumPad 0}", Key_numpad_0)
			Result.put (Locale * "{key-NumPad 1}", Key_numpad_1)
			Result.put (Locale * "{key-NumPad 2}", Key_numpad_2)
			Result.put (Locale * "{key-NumPad 3}", Key_numpad_3)
			Result.put (Locale * "{key-NumPad 4}", Key_numpad_4)
			Result.put (Locale * "{key-NumPad 5}", Key_numpad_5)
			Result.put (Locale * "{key-NumPad 6}", Key_numpad_6)
			Result.put (Locale * "{key-NumPad 7}", Key_numpad_7)
			Result.put (Locale * "{key-NumPad 8}", Key_numpad_8)
			Result.put (Locale * "{key-NumPad 9}", Key_numpad_9)
			Result.put (Locale * "{key-NumPad +}", Key_numpad_add)
			Result.put (Locale * "{key-NumPad /}", Key_numpad_divide)
			Result.put (Locale * "{key-NumPad *}", Key_numpad_multiply)
			Result.put (Locale * "{key-NumLock}", Key_num_lock)
			Result.put (Locale * "{key-NumPad -}", Key_numpad_subtract)
			Result.put (Locale * "{key-NumPad .}", Key_numpad_decimal)
			Result.put (Locale * "{key-F1}", Key_f1)
			Result.put (Locale * "{key-F2}", Key_f2)
			Result.put (Locale * "{key-F3}", Key_f3)
			Result.put (Locale * "{key-F4}", Key_f4)
			Result.put (Locale * "{key-F5}", Key_f5)
			Result.put (Locale * "{key-F6}", Key_f6)
			Result.put (Locale * "{key-F7}", Key_f7)
			Result.put (Locale * "{key-F8}", Key_f8)
			Result.put (Locale * "{key-F9}", Key_f9)
			Result.put (Locale * "{key-F10}", Key_f10)
			Result.put (Locale * "{key-F11}", Key_f11)
			Result.put (Locale * "{key-F12}", Key_f12)
			Result.put (Locale * "{key-Space}", Key_space)
			Result.put (Locale * "{key-BackSpace}", Key_back_space)
			Result.put (Locale * "{key-Enter}", Key_enter)
			Result.put (Locale * "{key-Esc}", Key_escape)
			Result.put (Locale * "{key-Tab}", Key_tab)
			Result.put (Locale * "{key-Pause}", Key_pause)
			Result.put (Locale * "{key-CapsLock}", Key_caps_lock)
			Result.put (Locale * "{key-ScrollLock}", Key_scroll_lock)
			Result.put (Locale * "{key-Up}", Key_up)
			Result.put (Locale * "{key-Down}", Key_down)
			Result.put (Locale * "{key-Left}", Key_left)
			Result.put (Locale * "{key-Right}", Key_right)
			Result.put (Locale * "{key-PageUp}", Key_page_up)
			Result.put (Locale * "{key-PageDown}", Key_page_down)
			Result.put (Locale * "{key-Home}", Key_home)
			Result.put (Locale * "{key-End}", Key_end)
			Result.put (Locale * "{key-Insert}", Key_insert)
			Result.put (Locale * "{key-Del}", Key_delete)
			Result.put (Locale * "{key-Shift}", Key_shift)
			Result.put (Locale * "{key-Ctrl}", Key_ctrl)
			Result.put (Locale * "{key-Alt}", Key_alt)
			Result.put (Locale * "{key-Left Meta}", Key_left_meta)
			Result.put (Locale * "{key-Right Meta}", Key_right_meta)
			Result.put (Locale * "{key-Menu}", Key_menu)
		end

end

