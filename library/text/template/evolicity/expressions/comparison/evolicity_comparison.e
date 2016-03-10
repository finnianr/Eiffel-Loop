note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EVOLICITY_COMPARISON

inherit
	EVOLICITY_BOOLEAN_EXPRESSION

	EL_MODULE_TYPING

feature -- Basic operation

	evaluate (context: EVOLICITY_CONTEXT)
			--
		do
			left_hand_expression.evaluate (context)
			right_hand_expression.evaluate (context)
			left_comparable := left_hand_expression.item
			right_comparable := right_hand_expression.item
			if not left_comparable.same_type (right_comparable) then
				harmonize_types
			end
			compare
		end

feature -- Element change

	set_left_hand_expression (expression: EVOLICITY_COMPARABLE)
			--
		do
			left_hand_expression := expression
		end

	set_right_hand_expression (expression: EVOLICITY_COMPARABLE)
			--
		do
			right_hand_expression := expression
		end

feature {NONE} -- Implementation

	compare
			--
		deferred
		end

	harmonize_types
			-- make types comparable
		local
			type_ids: ARRAY [INTEGER]
			operands: ARRAY [COMPARABLE]
		do
			if attached {NUMERIC} left_comparable as left and then attached {NUMERIC} right_comparable as right then
				type_ids := << Typing.dynamic_type (left), Typing.dynamic_type (right) >>
				if type_ids.there_exists (agent is_floating_type) then
					operands := double_operands (<< left_comparable, right_comparable >>)
				else
					operands := integer_64_operands (<< left_comparable, right_comparable >>)
				end
				left_comparable := operands [1]
				right_comparable := operands [2]
			end
		end

	double_operands (operands: ARRAY [COMPARABLE]): ARRAY [COMPARABLE]
			--
		local
			i: INTEGER
		do
			Result := operands
			from i := 1 until i > Result.count loop
				if attached {INTEGER_REF} Result.item (i) as integer then
					Result [i] := integer.to_double

				elseif attached {INTEGER_64_REF} Result.item (i) as integer_64 then
					Result [i] := integer_64.to_double

				elseif attached {NATURAL_32_REF} Result.item (i) as natural_32 then
					Result [i] := natural_32.to_real_64

				elseif attached {NATURAL_64_REF} Result.item (i) as natural_64 then
					Result [i] := natural_64.to_real_64

				elseif attached {REAL_REF} Result.item (i) as real then
					Result [i] := real.to_double

				end
				i := i + 1
			end
		end

	integer_64_operands (operands: ARRAY [COMPARABLE]): ARRAY [COMPARABLE]
			--
		local
			i: INTEGER
		do
			Result := operands
			from i := 1 until i > Result.count loop
				if attached {INTEGER_REF} Result.item (i) as integer then
					Result [i] := integer.to_integer_64

				elseif attached {NATURAL_32_REF} Result.item (i) as natural_32 then
					Result [i] := natural_32.to_integer_64

				elseif attached {NATURAL_64_REF} Result.item (i) as natural_64 then
					Result [i] := natural_64.to_integer_64

				end
				i := i + 1
			end
		end

	is_floating_type (type_id: INTEGER): BOOLEAN
			--
		do
			Result := type_id = Real_ref_type_id or type_id = Double_ref_type_id
		end

	left_hand_expression: EVOLICITY_COMPARABLE

	right_hand_expression: EVOLICITY_COMPARABLE

	left_comparable: COMPARABLE

	right_comparable: COMPARABLE

feature -- Constants

	Real_ref_type_id: INTEGER
			--
		once
			Result := Typing.dynamic_type (create {REAL_REF})
		end

	Double_ref_type_id: INTEGER
			--
		once
			Result := Typing.dynamic_type (create {DOUBLE_REF})
		end

end
