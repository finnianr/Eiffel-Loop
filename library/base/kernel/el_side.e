note
	description: "Expanded version of [$source EL_SIDE_ROUTINES] with abbreviated names"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-20 10:33:47 GMT (Monday 20th March 2023)"
	revision: "5"

expanded class
	EL_SIDE

inherit
	EL_EXPANDED_ROUTINES

	EL_SIDE_ROUTINES
		rename
			Both_sides as Both,
			Left_side as Left,
			Right_side as Right,
			No_sides as None
		export
			{ANY} all
		end

end