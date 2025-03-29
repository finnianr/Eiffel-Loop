note
	description: "Word case constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-29 13:09:53 GMT (Saturday 29th March 2025)"
	revision: "6"

class
	EL_CASE

feature -- Contract Support

	frozen is_valid (case: NATURAL_8): BOOLEAN
		do
			inspect case
				when Default_, Lower, Proper, Sentence, Upper then
					Result := True
			else

			end
		end

feature -- Constants

	Default_: NATURAL_8 = 0

	Lower: NATURAL_8 = 1
		-- Flag 001

	Proper: NATURAL_8 = 4
		-- Flag 100

	Sentence: NATURAL_8 = 8
		-- first letter only is upper cased
		-- Flag 1000

	Upper: NATURAL_8 = 2
		-- Flag 010

end