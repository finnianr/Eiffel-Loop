note
	description: "[
		Procedure identifier based on address of Eiffel routine dispatcher
		As it is not possible to compare agent references this serves as a workaround
		allowing you to determine whether two agents refer to the same procedure.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EL_PROCEDURE [OPEN_ARGS -> detachable TUPLE create default_create end]

inherit
	PROCEDURE [OPEN_ARGS]
		export
			{NONE} all
			{ANY} closed_operands, closed_count
		end

create
	make, default_create

convert
	make ({PROCEDURE [OPEN_ARGS]})

feature -- Initialization

	make, set_from_other (other: PROCEDURE)
			--
		do
			if other.encaps_rout_disp = Default_pointer then
				routine_id := other.routine_id
			else
				encaps_rout_disp := other.encaps_rout_disp
			end
			closed_operands := other.closed_operands
			is_target_closed := other.is_target_closed
			is_basic := other.is_basic
			open_count := other.open_count
		end

feature -- Comparison

	same_procedure (other: PROCEDURE): BOOLEAN
			--
		do
			if encaps_rout_disp = Default_pointer then
				Result := routine_id = other.routine_id
			else
				Result := encaps_rout_disp = other.encaps_rout_disp
			end
		end

end