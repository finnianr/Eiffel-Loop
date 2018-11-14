note
	description: "Apply routine with argument of type G"
	notes: "[
		The purpose of this class is to reuse argument tuples across calls resulting in less garbage collection
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-14 11:54:59 GMT (Wednesday 14th November 2018)"
	revision: "1"

class
	EL_ROUTINE_APPLICATOR [G]

create
	make

feature {NONE} -- Initialization

	make
		do
			create operands
		end

feature -- Basic operations

	apply (routine: ROUTINE; argument: G)
		-- apply `routine' with `argument'
		require
			valid_type: valid_type (argument)
			valid_operand: routine.valid_operands ([argument])
		do
			if routine.operands = operands then
				set_operands (operands, argument)
			else
				operands := [argument]
				routine.set_operands (operands)
			end
			routine.apply
		end

feature -- Contract Support

	valid_type (argument: G): BOOLEAN
		do
			Result := operands.valid_type_for_index (argument, 1)
		end

feature {NONE} -- Implementation

	set_operands (a_operands: like operands; argument: G)
		do
			a_operands.put (argument, 1)
		end

feature {NONE} -- Internal attributes

	operands: TUPLE [G]

end
