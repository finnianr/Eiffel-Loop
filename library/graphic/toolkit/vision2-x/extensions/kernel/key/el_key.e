note
	description: "[
		Represents keyboard key using a virtual key code. `code' can be any
		of the constant values defined in ${EV_KEY_CONSTANTS}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-28 12:18:44 GMT (Sunday 28th January 2024)"
	revision: "5"

class
	EL_KEY

inherit
	EV_KEY
		rename
			text as to_text_32
		end

	EL_KEY_MODIFIER_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, out
		end

	EL_SHARED_VISION_2_TEXTS

	EL_SHARED_KEY_TEXTS

create
	default_create, make_with_code

convert
	make_with_code ({INTEGER})

feature -- Access

	name: ZSTRING
		local
			index: INTEGER
		do
			inspect code
				when Key_0 .. Key_9 then
					create Result.make (1)
					Result.append_integer (code - Key_0)

				when Key_a .. Key_z then
					create Result.make_filled ('A' + (code - Key_a), 1)

				when Key_numpad_0 .. Key_numpad_9 then
					Result := Text.numeric_pad_template #$ [code - Key_numpad_0]

				when Key_numpad_add .. Key_numpad_multiply, Key_numpad_subtract, Key_numpad_decimal then
					index := 1 + code - Key_numpad_add
					if Numeric_pad_operators.valid_index (index) then
						Result := Text.numeric_pad_template #$ [Numeric_pad_operators [index]]
					else
						Result := Text.numeric_pad_template
					end

				when Key_f1 .. Key_f12 then
					create Result.make (3)
					Result.append_character_8 ('F')
					Result.append_integer (1 + code - Key_f1)

			else
				if Key_text.table.valid_index (code) then
					Result := Key_text.table [code]
				else
					create Result.make_empty
				end
			end
		end

	description (combined_modifiers: NATURAL): ZSTRING
		-- description of key with `code' with `combined_modifiers' keys
		-- Eg. Ctrl+Shift+Delete
		do
			create Result.make (8)
			across Modifier_list as modifer loop
				if (combined_modifiers & modifer.item.code).to_boolean then
					if not Result.is_empty then
						Result.append_character ('+')
					end
					Result.append (modifer.item.name)
				end
			end
			if not Result.is_empty then
				Result.append_character ('+')
			end
			Result.append (name)
		end

feature {NONE} -- Constants

	Modifier_list: ARRAY [TUPLE [code: NATURAL; name: ZSTRING]]
		once
			Result := <<
				[Alt, Key_text.table [Key_alt]],
				[Ctrl, Key_text.table [Key_ctrl]],
				[Shift, Key_text.table [Key_shift]]
			>>
		end

	Numeric_pad_operators: STRING = "+/*L-."
		-- L stand for Numeric Lock

end