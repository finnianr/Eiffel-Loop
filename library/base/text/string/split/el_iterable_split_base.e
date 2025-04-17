note
	description: "Iterable string split with separator of type **SEPAR**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 13:36:40 GMT (Thursday 17th April 2025)"
	revision: "2"

deferred class
	EL_ITERABLE_SPLIT_BASE [RSTRING -> READABLE_STRING_GENERAL, SEPARATOR]

inherit
	EL_SIDE_ROUTINES
		export
			{ANY} valid_side
		end

feature {NONE} -- Initialization

	initialize
		deferred
		end

	make (a_target: like target; a_separator: like separator)
		do
			make_adjusted (a_target, a_separator, No_sides)
		end

	make_adjusted (a_target: like target; a_separator: like separator; a_adjustments: INTEGER)
		-- `a_target' split by `a_separator' character/string and space adjusted according to `adjustments':
		-- `Both', `Left', `None', `Right' from class `EL_SIDE'.
		require
			valid_adjustments: valid_side (adjustments)
		do
			target := a_target; adjustments := a_adjustments
			set_separator (a_separator)
			initialize
		end

feature -- Access

	separator_count: INTEGER
		do
			Result := 1
		end

	target: RSTRING

feature -- Status query

	left_adjusted: BOOLEAN
		do
			Result := has_left_side (adjustments)
		end

	right_adjusted: BOOLEAN
		do
			Result := has_right_side (adjustments)
		end

feature -- Element change

	set_adjustments (a_adjustments: like adjustments)
		require
			valid_side: valid_side (a_adjustments)
		do
			adjustments := a_adjustments
		end

	set_separator (a_separator: like separator)
		do
			separator := a_separator
		end

	set_target (a_target: like target)
		do
			target := a_target
		end

feature {NONE} -- Internal attributes

	adjustments: INTEGER
		-- One of: `Both', `Left', `None', `Right' from class `EL_SIDE'.

	separator: SEPARATOR

end