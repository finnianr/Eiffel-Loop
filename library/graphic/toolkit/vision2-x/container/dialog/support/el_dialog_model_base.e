note
	description: "Implementation classes and routines for ${EL_DIALOG_MODEL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-29 14:55:02 GMT (Saturday 29th March 2025)"
	revision: "6"

deferred class
	EL_DIALOG_MODEL_BASE

inherit
	ANY

	EL_STRING_GENERAL_ROUTINES

	EL_MODULE_ITERABLE; EL_MODULE_TEXT; EL_MODULE_SCREEN

	EL_STRING_8_CONSTANTS

	EL_SHARED_DEFAULT_PIXMAPS; EL_SHARED_WORD

feature {NONE} -- Implementation

	default_layout: EL_DIALOG_LAYOUT
		do
			create Result.make
		end

	default_style: EL_DIALOG_STYLE
		do
			create Result.make
		end

	new_paragraph_list (list_general: ITERABLE [READABLE_STRING_GENERAL]): EL_ZSTRING_LIST
		local
			lines: EL_ZSTRING_LIST; l_text: ZSTRING
		do
			create Result.make (Iterable.count (list_general))
			across list_general as paragraph loop
				l_text := as_zstring (paragraph.item)
				if text.has ('%N') then
					create lines.make_with_lines (l_text)
					Result.extend (lines.as_word_string)
				else
					Result.extend (l_text)
				end
			end
		end

feature {NONE} -- Deferred

	text: READABLE_STRING_GENERAL
		deferred
		end

feature {NONE} -- Internal attributes

	internal_paragraph_list: detachable like new_paragraph_list

feature {NONE} -- Constants

	Default_icon: EV_PIXMAP
		once
			Result := Pixmaps.Information_pixmap
		end

end