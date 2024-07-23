note
	description: "Word case constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-23 15:35:30 GMT (Tuesday 23rd July 2024)"
	revision: "5"

class
	EL_CASE

inherit
	ANY
		rename
			default as default_object
		end

feature -- Contract Support

	frozen is_valid (case: NATURAL_8): BOOLEAN
		do
			inspect case
				when Default, Lower, Proper, Sentence, Upper then
					Result := True
			else

			end
		end

feature -- Constants

	Default: NATURAL_8 = 0

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