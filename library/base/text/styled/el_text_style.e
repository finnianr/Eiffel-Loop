note
	description: "Text style constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-02 10:17:59 GMT (Wednesday 2nd September 2020)"
	revision: "1"

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

feature -- Constants

	Bold: INTEGER = 0

	Monospaced: INTEGER = 1

	Monospaced_bold: INTEGER = 2

	Regular: INTEGER = 3

end
