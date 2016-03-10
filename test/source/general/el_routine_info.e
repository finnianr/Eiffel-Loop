note
	description: "Summary description for {EL_ROUTINE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:31 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_ROUTINE_INFO

inherit
	ROUTINE [ANY, TUPLE]
		rename
			target as routine_target
		end

	EL_MODULE_EIFFEL
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
			offset := Eiffel.field_offset (feature_id, target)
			Result := Eiffel.field_name (feature_id, target)
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
