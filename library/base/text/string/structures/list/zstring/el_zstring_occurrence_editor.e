note
	description: "Object that edits substring intervals of a [$source ZSTRING] instance"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-08 14:30:46 GMT (Wednesday 8th March 2023)"
	revision: "1"

class
	EL_ZSTRING_OCCURRENCE_EDITOR

inherit
	EL_OCCURRENCE_EDITOR [ZSTRING]
		undefine
			default_target, fill_by_string
		redefine
			target
		end

	EL_ZSTRING_OCCURRENCE_IMPLEMENTATION

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string

feature {NONE} -- Implementation

	reuseable_scope: like Reuseable.string
		do
			Result := Reuseable.string
		end

	wipe_out_target
		do
			target.wipe_out
		end

feature {NONE} -- Internal attributes

	target: ZSTRING

end