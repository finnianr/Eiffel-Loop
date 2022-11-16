note
	description: "Iterable string split with separator of type **G**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "6"

deferred class
	EL_ITERABLE_SPLIT [S -> READABLE_STRING_GENERAL, G]

inherit
	ITERABLE [S]

feature {NONE} -- Initialization

	make (a_target: like target; a_separator: like separator)
		do
			make_adjusted (a_target, a_separator, 0)
		end

	make_adjusted (a_target: like target; a_separator: like separator; a_adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (adjustments)
		do
			target := a_target; separator := a_separator; adjustments := a_adjustments
		end

feature -- Access

	new_cursor: EL_ITERABLE_SPLIT_CURSOR [S, G]
			-- Fresh cursor associated with current structure
		deferred
		end

	count: INTEGER
		do
			across Current as item loop
				Result := Result + 1
			end
		end

	target: S

feature -- Status query

	left_adjusted: BOOLEAN
		do
			Result := (adjustments & {EL_STRING_ADJUST}.Left).to_boolean
		end

	right_adjusted: BOOLEAN
		do
			Result := (adjustments & {EL_STRING_ADJUST}.Right).to_boolean
		end

feature -- Element change

	set_target (a_target: like target)
		do
			target := a_target
		end

feature -- Contract Support

	valid_adjustments (bitmap: INTEGER): BOOLEAN
		do
			Result := 0 <= bitmap and then bitmap <= {EL_STRING_ADJUST}.Both
		end

feature {NONE} -- Internal attributes

	adjustments: INTEGER

	separator: G

end