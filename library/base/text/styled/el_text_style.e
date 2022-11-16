note
	description: "Text style constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_TEXT_STYLE

feature -- Contract Support

	is_valid_style (style: INTEGER): BOOLEAN
		do
			inspect style
				when Bold, Monospaced, Monospaced_bold, Regular then
					Result := True
			else
			end
		end

feature -- Styles

	Regular: INTEGER = 1

	Bold: INTEGER = 2

	Monospaced: INTEGER = 3

	Monospaced_bold: INTEGER = 4

end