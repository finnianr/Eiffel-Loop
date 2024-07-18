note
	description: "[
		Represents keyboard key using a virtual key code. `code' can be any
		of the constant values defined in ${EV_KEY_CONSTANTS}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-18 11:58:36 GMT (Thursday 18th July 2024)"
	revision: "7"

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
	default_create, make_with_code, make_combined

convert
	make_with_code ({INTEGER}), make_combined ({NATURAL})

feature {NONE} -- Initialization

	make_combined (key_and_modifier_code: NATURAL)
		-- make with key code combined with `Alt', `Ctrl', `Shift' combined_modifiers
		do
			make_with_code (key_and_modifier_code.to_natural_16.to_integer_32)
			combined_modifiers := (key_and_modifier_code |>> 16).to_natural_8
		end

feature -- Status query

	require_shift: BOOLEAN
		do
			Result := requires_modifier (Shift)
		end

	require_control: BOOLEAN
		do
			Result := requires_modifier (Ctrl)
		end

	require_alt: BOOLEAN
		do
			Result := requires_modifier (Alt)
		end

feature -- Access

	description: ZSTRING
		-- description of key with `code' with `combined_modifiers' keys
		-- Eg. Ctrl+Shift+Delete
		local
			modifier_code: NATURAL; parts: EL_ZSTRING_LIST
		do
			create parts.make (4)
			across Valid_modifiers as list loop
				modifier_code := list.item
				if (combined_modifiers.to_natural_32 & modifier_code).to_boolean then
					parts.extend (Key_text.table [as_modifier_key (modifier_code)])
				end
			end
			parts.extend (name)
			Result := parts.joined ('+')
		end

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

feature {NONE} -- Implementation

	requires_modifier (type: NATURAL): BOOLEAN
		do
			Result := (combined_modifiers.to_natural_32 & type).to_boolean
		end

	as_modifier_key (modifier: NATURAL): INTEGER
		do
			inspect modifier
				when Alt then
					Result := Key_alt
				when Ctrl then
					Result := Key_ctrl
				when Shift then
					Result := Key_shift
			else
			end
		end

feature {NONE} -- Internal attributes

	combined_modifiers: NATURAL_8

feature {NONE} -- Constants

	Numeric_pad_operators: STRING = "+/*L-."
		-- L stand for Numeric Lock

end