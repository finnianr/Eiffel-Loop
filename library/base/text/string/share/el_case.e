note
	description: "Word case constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 9:43:29 GMT (Tuesday 8th April 2025)"
	revision: "7"

frozen class
	EL_CASE

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