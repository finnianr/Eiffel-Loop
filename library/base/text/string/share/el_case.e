note
	description: "Word case constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-23 9:27:25 GMT (Saturday 23rd December 2023)"
	revision: "4"

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
				when Default, Lower, Proper, Upper then
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

	Upper: NATURAL_8 = 2
		-- Flag 010

end