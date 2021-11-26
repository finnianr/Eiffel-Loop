note
	description: "Iterable string split with separator of type **G**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-26 11:21:34 GMT (Friday 26th November 2021)"
	revision: "1"

deferred class
	EL_ITERABLE_SPLIT [S -> READABLE_STRING_GENERAL create make end, G]

inherit
	ITERABLE [S]

feature {NONE} -- Initialization

	make (a_target: like target; a_separator: like separator)
		do
			target := a_target; separator := a_separator
		end

feature -- Access

	new_cursor: EL_ITERABLE_SPLIT_CURSOR [S, G]
			-- Fresh cursor associated with current structure
		deferred
		end

feature -- Status query

	left_adjusted: BOOLEAN

	right_adjusted: BOOLEAN

	skip_empty: BOOLEAN

feature -- Status change

	set_left_adjusted (status: BOOLEAN)
		do
			left_adjusted := status
		end

	set_right_adjusted (status: BOOLEAN)
		do
			right_adjusted := status
		end

	set_skip_empty (status: BOOLEAN)
		do
			skip_empty := status
		end

feature {NONE} -- Internal attributes

	separator: G

	target: S

end