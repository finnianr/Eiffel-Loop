note
	description: "Object that edits substring intervals of a [$source STRING_32] instance"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-08 14:30:35 GMT (Wednesday 8th March 2023)"
	revision: "1"

class
	EL_STRING_32_OCCURRENCE_EDITOR

inherit
	EL_OCCURRENCE_EDITOR [STRING_32]
		undefine
			fill_by_string
		redefine
			default_target, target
		end

	EL_STRING_32_OCCURRENCE_IMPLEMENTATION [STRING_32]

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string

feature {NONE} -- Implementation

	default_target: STRING_32
		do
			Result := Empty_string_32
		end

	reuseable_scope: like Reuseable.string_32
		do
			Result := Reuseable.string_32
		end

	wipe_out_target
		do
			target.wipe_out
		end

feature {NONE} -- Internal attributes

	target: STRING_32

end