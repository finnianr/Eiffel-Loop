note
	description: "Numeric calculations that can be applied across container items"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-30 7:51:40 GMT (Monday 30th September 2024)"
	revision: "4"

deferred class
	EL_CUMULATIVE_CONTAINER_ARITHMETIC [G]

feature -- Maximum

	max_double (value: FUNCTION [G, DOUBLE]): DOUBLE
			-- maximum of call to `value' function
		do
			Result := double_arithmetic.max (value)
		end

	max_double_meeting (value: FUNCTION [G, DOUBLE]; condition: EL_QUERY_CONDITION [G]): DOUBLE
			-- maximum of call to `value' function for all items meeting `condition'
		do
			Result := double_arithmetic.max_meeting (value, condition)
		end

	max_integer (value: FUNCTION [G, INTEGER]): INTEGER
			-- maximum of call to `value' function
		do
			Result := integer_arithmetic.max (value)
		end

	max_integer_meeting (value: FUNCTION [G, INTEGER]; condition: EL_QUERY_CONDITION [G]): INTEGER
			-- maximum of call to `value' function for all items meeting `condition'
		do
			Result := integer_arithmetic.max_meeting (value, condition)
		end

	max_natural (value: FUNCTION [G, NATURAL]): NATURAL
			-- maximum of call to `value' function
		do
			Result := natural_arithmetic.max (value)
		end

	max_natural_meeting (value: FUNCTION [G, NATURAL]; condition: EL_QUERY_CONDITION [G]): NATURAL
			-- maximum of call to `value' function for all items meeting `condition'
		do
			Result := natural_arithmetic.max_meeting (value, condition)
		end

	max_real (value: FUNCTION [G, REAL]): REAL
			-- maximum of call to `value' function
		do
			Result := real_arithmetic.max (value)
		end

	max_real_meeting (value: FUNCTION [G, REAL]; condition: EL_QUERY_CONDITION [G]): REAL
			-- maximum of call to `value' function for all items meeting `condition'
		do
			Result := real_arithmetic.max_meeting (value, condition)
		end

feature -- Minimum

	min_double (value: FUNCTION [G, DOUBLE]): DOUBLE
			-- minimum of call to `value' function
		do
			Result := double_arithmetic.min (value)
		end

	min_double_meeting (value: FUNCTION [G, DOUBLE]; condition: EL_QUERY_CONDITION [G]): DOUBLE
			-- minimum of call to `value' function for all items meeting `condition'
		do
			Result := double_arithmetic.min_meeting (value, condition)
		end

	min_integer (value: FUNCTION [G, INTEGER]): INTEGER
			-- minimum of call to `value' function
		do
			Result := integer_arithmetic.min (value)
		end

	min_integer_meeting (value: FUNCTION [G, INTEGER]; condition: EL_QUERY_CONDITION [G]): INTEGER
			-- minimum of call to `value' function for all items meeting `condition'
		do
			Result := integer_arithmetic.min_meeting (value, condition)
		end

	min_natural (value: FUNCTION [G, NATURAL]): NATURAL
			-- minimum of call to `value' function
		do
			Result := natural_arithmetic.min (value)
		end

	min_natural_meeting (value: FUNCTION [G, NATURAL]; condition: EL_QUERY_CONDITION [G]): NATURAL
			-- minimum of call to `value' function for all items meeting `condition'
		do
			Result := natural_arithmetic.min_meeting (value, condition)
		end

	min_real (value: FUNCTION [G, REAL]): REAL
			-- minimum of call to `value' function
		do
			Result := real_arithmetic.min (value)
		end

	min_real_meeting (value: FUNCTION [G, REAL]; condition: EL_QUERY_CONDITION [G]): REAL
			-- minimum of call to `value' function for all items meeting `condition'
		do
			Result := real_arithmetic.min_meeting (value, condition)
		end

feature -- Sum

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