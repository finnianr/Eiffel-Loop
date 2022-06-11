note
	description: "Check for source modifications using distributed callbacks"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-11 9:44:09 GMT (Saturday 11th June 2022)"
	revision: "12"

class
	EIFFEL_CLASS_UPDATE_CHECKER

inherit
	EL_DISTRIBUTED_PROCEDURE_CALLBACK

	EL_MODULE_TUPLE

create
	make

feature -- Basic operations

	queue (update_class: PROCEDURE)
		require
			valid_operand: valid_operands (update_class)
		do
			wait_apply (agent do_nothing_or_update_class (update_class))
		end

feature -- Contract Support

	valid_operands (update_class: PROCEDURE): BOOLEAN
		do
			if attached Tuple.closed_operands (update_class) as operands and then operands.count = 3 then
				Result := attached {EIFFEL_CLASS} operands.reference_item (3)
			end
		end

feature {NONE} -- Separate function

	do_nothing_or_update_class (update_class: PROCEDURE): PROCEDURE
		-- check if source for `e_class' has been modified
		do
			if attached {EIFFEL_CLASS} Tuple.closed_operands (update_class).reference_item (3) as e_class then
				if e_class.is_source_modified then
					Result := update_class
				else
					Result := agent do_nothing
				end
			end
		end

end