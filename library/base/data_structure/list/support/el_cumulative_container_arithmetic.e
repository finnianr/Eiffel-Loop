note
	description: "Numeric calculations that can be applied across container items"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-02 14:27:55 GMT (Monday 2nd September 2024)"
	revision: "2"

deferred class
	EL_CUMULATIVE_CONTAINER_ARITHMETIC [G]

feature -- Maximum

	maximum_double (value: FUNCTION [G, DOUBLE]): DOUBLE
			-- maximum of call to `value' function
		do
			Result := double_arithmetic.maximum (value)
		end

	maximum_double_meeting (value: FUNCTION [G, DOUBLE]; condition: EL_QUERY_CONDITION [G]): DOUBLE
			-- maximum of call to `value' function for all items meeting `condition'
		do
			Result := double_arithmetic.maximum_meeting (value, condition)
		end

	maximum_integer (value: FUNCTION [G, INTEGER]): INTEGER
			-- maximum of call to `value' function
		do
			Result := integer_arithmetic.maximum (value)
		end

	maximum_integer_meeting (value: FUNCTION [G, INTEGER]; condition: EL_QUERY_CONDITION [G]): INTEGER
			-- maximum of call to `value' function for all items meeting `condition'
		do
			Result := integer_arithmetic.maximum_meeting (value, condition)
		end

	maximum_natural (value: FUNCTION [G, NATURAL]): NATURAL
			-- maximum of call to `value' function
		do
			Result := natural_arithmetic.maximum (value)
		end

	maximum_natural_meeting (value: FUNCTION [G, NATURAL]; condition: EL_QUERY_CONDITION [G]): NATURAL
			-- maximum of call to `value' function for all items meeting `condition'
		do
			Result := natural_arithmetic.maximum_meeting (value, condition)
		end

	maximum_real (value: FUNCTION [G, REAL]): REAL
			-- maximum of call to `value' function
		do
			Result := real_arithmetic.maximum (value)
		end

	maximum_real_meeting (value: FUNCTION [G, REAL]; condition: EL_QUERY_CONDITION [G]): REAL
			-- maximum of call to `value' function for all items meeting `condition'
		do
			Result := real_arithmetic.maximum_meeting (value, condition)
		end

feature -- Summation

	sum_double (value: FUNCTION [G, DOUBLE]): DOUBLE
			-- sum of call to `value' function
		do
			Result := double_arithmetic.sum (value)
		end

	sum_double_meeting (value: FUNCTION [G, DOUBLE]; condition: EL_QUERY_CONDITION [G]): DOUBLE
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := double_arithmetic.sum_meeting (value, condition)
		end

	sum_integer (value: FUNCTION [G, INTEGER]): INTEGER
			-- sum of call to `value' function
		do
			Result := integer_arithmetic.sum (value)
		end

	sum_integer_meeting (value: FUNCTION [G, INTEGER]; condition: EL_QUERY_CONDITION [G]): INTEGER
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := integer_arithmetic.sum_meeting (value, condition)
		end

	sum_natural (value: FUNCTION [G, NATURAL]): NATURAL
			-- sum of call to `value' function
		do
			Result := natural_arithmetic.sum (value)
		end

	sum_natural_meeting (value: FUNCTION [G, NATURAL]; condition: EL_QUERY_CONDITION [G]): NATURAL
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := natural_arithmetic.sum_meeting (value, condition)
		end

	sum_real (value: FUNCTION [G, REAL]): REAL
			-- sum of call to `value' function
		do
			Result := real_arithmetic.sum (value)
		end

	sum_real_meeting (value: FUNCTION [G, REAL]; condition: EL_QUERY_CONDITION [G]): REAL
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := real_arithmetic.sum_meeting (value, condition)
		end

feature {NONE} -- Result arithmetic

	integer_arithmetic: EL_CONTAINER_ARITHMETIC [G, INTEGER]
		do
			create Result.make (current_container)
		end

	natural_arithmetic: EL_CONTAINER_ARITHMETIC [G, NATURAL]
		do
			create Result.make (current_container)
		end

	real_arithmetic: EL_CONTAINER_ARITHMETIC [G, REAL]
		do
			create Result.make (current_container)
		end

	double_arithmetic: EL_CONTAINER_ARITHMETIC [G, DOUBLE]
		do
			create Result.make (current_container)
		end

feature {NONE} -- Deferred implementation

	current_container: CONTAINER [G]
		-- assign Current to Result in descendant
		deferred
		end
end