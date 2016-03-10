note
	description: "Summary description for {EL_ROUTINE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:21 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_ROUTINE_INFO

inherit
	ROUTINE [ANY, TUPLE]
		rename
			target as routine_target
		end

	EL_MODULE_TYPING
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (other: ROUTINE [ANY, TUPLE])
			--
		do
			target := other.target
			feature_id := other.feature_id
		end

feature -- Access

	name: STRING
			--
		local
			offset: INTEGER
		do
			offset := Typing.field_offset (feature_id, target)
			Result := Typing.field_name (feature_id, target)
		end

feature {NONE} -- Implementation

	call (args: detachable TUPLE)
			--
		do
		end

	apply
			--
		do
		end

	target: detachable ANY

end
