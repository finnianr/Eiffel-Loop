note
	description: "Names of punctuation and control keys accessible via [$source EL_SHARED_KEY_TEXTS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-04-20 6:23:04 GMT (Wednesday 20th April 2022)"
	revision: "1"

class
	EL_KEY_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS
		redefine
			initialize_fields, title_case_texts
		end

	EL_ZSTRING_CONSTANTS

	EV_KEY_CONSTANTS
		export
			{NONE} all
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	initialize_fields
		do
			Precursor
			create table.make_filled (Empty_string, 1, Key_menu)
			table [Key_alt] := alt
			table [Key_back_space] := backspace
			table [Key_backquote] := backquote
			table [Key_backslash] := backslash
			table [Key_caps_lock] := caps_lock
			table [Key_close_bracket] := close_bracket
			table [Key_comma] := comma
			table [Key_ctrl] := ctrl
			table [Key_dash] := dash_key
			table [Key_delete] := delete
			table [Key_down] := down_arrow
			table [Key_end] := end_key
			table [Key_enter] := enter
			table [Key_equal] := equal_key
			table [Key_escape] := escape_key

			table [Key_home] := home_key
			table [Key_insert] := insert_key
			table [Key_left] := left
			table [Key_left_meta] := left_meta
			table [Key_menu] := menu_key
			table [Key_num_lock] := numeric_lock

			table [Key_open_bracket] := open_bracket
			table [Key_page_down] := page_down
			table [Key_page_up] := page_up
			table [Key_pause] := pause_key
			table [Key_period] := period_key
			table [Key_quote] := quote_key
			table [Key_right] := right
			table [Key_right_meta] := right_meta
			table [Key_scroll_lock] := scroll_lock
			table [Key_semicolon] := semicolon
			table [Key_shift] := shift_key

			table [Key_slash] := slash_key
			table [Key_space] := space_key
			table [Key_tab] := tab_key
			table [Key_up] := up_arrow
		end

feature -- Access

	table: ARRAY [ZSTRING] note option: transient attribute end
		-- name table indexed by `EV_KEY_CONSTANTS' value

feature -- Keys

	alt: ZSTRING

	backspace: ZSTRING

	backquote: ZSTRING

	backslash: ZSTRING

	caps_lock: ZSTRING

	close_bracket: ZSTRING

	comma: ZSTRING

	ctrl: ZSTRING

	dash_key: ZSTRING

	delete: ZSTRING

	down_arrow: ZSTRING

	end_key: ZSTRING

	enter: ZSTRING

	equal_key: ZSTRING

	escape_key: ZSTRING

	home_key: ZSTRING

	insert_key: ZSTRING

	left: ZSTRING

	left_meta: ZSTRING

	menu_key: ZSTRING

	numeric_lock: ZSTRING

	open_bracket: ZSTRING

	page_down: ZSTRING

	page_up: ZSTRING

	pause_key: ZSTRING

	period_key: ZSTRING

	quote_key: ZSTRING

	right: ZSTRING

	right_meta: ZSTRING

	scroll_lock: ZSTRING

	semicolon: ZSTRING

	shift_key: ZSTRING

	slash_key: ZSTRING

	space_key: ZSTRING

	tab_key: ZSTRING

	up_arrow: ZSTRING

feature {NONE} -- Implementation

	english_table: STRING
		do
			Result := "[
				dash_key:
					Dash
				end_key:
					End
				equal_key:
					Equal
				escape_key:
					Escape
				home_key:
					Home
				insert_key:
					Insert
				menu_key:
					Menu
				pause_key:
					Pause
				period_key:
					Period
				quote_key:
					Quote
				shift_key:
					Shift
				slash_key:
					Slash
				space_key:
					Space
				tab_key:
					Tab
			]"
		end

	title_case_texts: like None
		-- English key texts that are entirely title case (First letter of each word capatilized)
		do
			Result := all_texts
		end

end