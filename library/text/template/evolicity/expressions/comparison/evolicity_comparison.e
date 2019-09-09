note
	description: "Evolicity comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	EVOLICITY_COMPARISON

inherit
	EVOLICITY_BOOLEAN_EXPRESSION

	EL_MODULE_EIFFEL

feature -- Basic operation

	evaluate (context: EVOLICITY_CONTEXT)
			--
		local
			left, right: COMPARABLE
		do
			left_hand_expression.evaluate (context)
			right_hand_expression.evaluate (context)
			left := left_hand_expression.item; right := right_hand_expression.item

			if left.same_type (right) then
				compare (left, right)
			elseif attached {NUMERIC} left as left_numeric and then attached {NUMERIC} right as right_numeric then
				if is_real_type (left_numeric) or else is_real_type (right_numeric) then
					compare_double (to_double (left_numeric), to_double (right_numeric))
				else
					compare_integer_64 (to_integer_64 (left_numeric), to_integer_64 (right_numeric))
				end
 			end
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

	compare (left, right: COMPARABLE)
			--
		deferred
		end

	compare_double (left, right: DOUBLE)
		deferred
		end

	compare_integer_64 (left, right: INTEGER_64)
		deferred
		end

	to_double (n: NUMERIC): DOUBLE
			--
		do
			if attached {REAL_32_REF} n as r_32 then
				Result := r_32.to_double
			elseif attached {REAL_64_REF} n as r_64 then
				Result := r_64.item

			elseif attached {INTEGER_8_REF} n as i_8 then
				Result := i_8.to_double
			elseif attached {INTEGER_16_REF} n as i_16 then
				Result := i_16.to_double
			elseif attached {INTEGER_32_REF} n as i_32 then
				Result := i_32.to_double
			elseif attached {INTEGER_64_REF} n as i_64 then
				Result := i_64.to_double

			elseif attached {NATURAL_8_REF} n as n_8 then
				Result := n_8.to_real_64
			elseif attached {NATURAL_16_REF} n as n_16 then
				Result := n_16.to_real_64
			elseif attached {NATURAL_32_REF} n as n_32 then
				Result := n_32.to_real_64
			elseif attached {NATURAL_64_REF} n as n_64 then
				Result := n_64.to_real_64

			end
		end

	to_integer_64 (n: NUMERIC): INTEGER_64
			--
		do
			if attached {INTEGER_8_REF} n as i_8 then
				Result := i_8.to_integer_64
			elseif attached {INTEGER_16_REF} n as i_16 then
				Result := i_16.to_integer_64
			elseif attached {INTEGER_32_REF} n as i_32 then
				Result := i_32.to_integer_64
			elseif attached {INTEGER_64_REF} n as i_64 then
				Result := i_64.item

			elseif attached {NATURAL_8_REF} n as n_8 then
				Result := n_8.to_integer_64
			elseif attached {NATURAL_16_REF} n as n_16 then
				Result := n_16.to_integer_64
			elseif attached {NATURAL_32_REF} n as n_32 then
				Result := n_32.to_integer_64
			elseif attached {NATURAL_64_REF} n as n_64 then
				Result := n_64.to_integer_64

			elseif attached {REAL_32_REF} n as r_32 then
				Result := r_32.truncated_to_integer_64
			elseif attached {REAL_64_REF} n as r_64 then
				Result := r_64.truncated_to_integer_64

			end
		end

	is_real_type (n: NUMERIC): BOOLEAN
			--
		do
			Result := attached {REAL_64_REF} n or else attached {REAL_32_REF} n
		end

feature {NONE} -- Internal attributes

	left_hand_expression: EVOLICITY_COMPARABLE

	right_hand_expression: EVOLICITY_COMPARABLE

end
