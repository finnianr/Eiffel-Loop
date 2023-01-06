note
	description: "Numeric calculations that can be applied across container items"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-06 13:17:24 GMT (Friday 6th January 2023)"
	revision: "1"

deferred class
	EL_CONTAINER_NUMERIC_CALCULATER [G]

feature -- Maximum

	maximum_double (value: FUNCTION [G, DOUBLE]): DOUBLE
			-- maximum of call to `value' function
		do
			Result := double_maximum.maximum (value)
		end

	maximum_double_meeting (value: FUNCTION [G, DOUBLE]; condition: EL_QUERY_CONDITION [G]): DOUBLE
			-- maximum of call to `value' function for all items meeting `condition'
		do
			Result := double_maximum.maximum_meeting (value, condition)
		end

	maximum_integer (value: FUNCTION [G, INTEGER]): INTEGER
			-- maximum of call to `value' function
		do
			Result := integer_maximum.maximum (value)
		end

	maximum_integer_meeting (value: FUNCTION [G, INTEGER]; condition: EL_QUERY_CONDITION [G]): INTEGER
			-- maximum of call to `value' function for all items meeting `condition'
		do
			Result := integer_maximum.maximum_meeting (value, condition)
		end

	maximum_natural (value: FUNCTION [G, NATURAL]): NATURAL
			-- maximum of call to `value' function
		do
			Result := natural_maximum.maximum (value)
		end

	maximum_natural_meeting (value: FUNCTION [G, NATURAL]; condition: EL_QUERY_CONDITION [G]): NATURAL
			-- maximum of call to `value' function for all items meeting `condition'
		do
			Result := natural_maximum.maximum_meeting (value, condition)
		end

	maximum_real (value: FUNCTION [G, REAL]): REAL
			-- maximum of call to `value' function
		do
			Result := real_maximum.maximum (value)
		end

	maximum_real_meeting (value: FUNCTION [G, REAL]; condition: EL_QUERY_CONDITION [G]): REAL
			-- maximum of call to `value' function for all items meeting `condition'
		do
			Result := real_maximum.maximum_meeting (value, condition)
		end

feature -- Summation

	sum_double (value: FUNCTION [G, DOUBLE]): DOUBLE
			-- sum of call to `value' function
		do
			Result := double_summator.sum (value)
		end

	sum_double_meeting (value: FUNCTION [G, DOUBLE]; condition: EL_QUERY_CONDITION [G]): DOUBLE
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := double_summator.sum_meeting (value, condition)
		end

	sum_integer (value: FUNCTION [G, INTEGER]): INTEGER
			-- sum of call to `value' function
		do
			Result := integer_summator.sum (value)
		end

	sum_integer_meeting (value: FUNCTION [G, INTEGER]; condition: EL_QUERY_CONDITION [G]): INTEGER
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := integer_summator.sum_meeting (value, condition)
		end

	sum_natural (value: FUNCTION [G, NATURAL]): NATURAL
			-- sum of call to `value' function
		do
			Result := natural_summator.sum (value)
		end

	sum_natural_meeting (value: FUNCTION [G, NATURAL]; condition: EL_QUERY_CONDITION [G]): NATURAL
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := natural_summator.sum_meeting (value, condition)
		end

	sum_real (value: FUNCTION [G, REAL]): REAL
			-- sum of call to `value' function
		do
			Result := real_summator.sum (value)
		end

	sum_real_meeting (value: FUNCTION [G, REAL]; condition: EL_QUERY_CONDITION [G]): REAL
			-- sum of call to `value' function for all items meeting `condition'
		do
			Result := real_summator.sum_meeting (value, condition)
		end

feature {NONE} -- Result maximums

	integer_maximum: EL_RESULT_MAXIMUM [G, INTEGER]
		do
			create Result.make (current_container)
		end

	natural_maximum: EL_RESULT_MAXIMUM [G, NATURAL]
		do
			create Result.make (current_container)
		end

	real_maximum: EL_RESULT_MAXIMUM [G, REAL]
		do
			create Result.make (current_container)
		end

	double_maximum: EL_RESULT_MAXIMUM [G, DOUBLE]
		do
			create Result.make (current_container)
		end

feature {NONE} -- Result summators

	integer_summator: EL_RESULT_SUMMATOR [G, INTEGER]
		do
			create Result.make (current_container)
		end

	natural_summator: EL_RESULT_SUMMATOR [G, NATURAL]
		do
			create Result.make (current_container)
		end

	real_summator: EL_RESULT_SUMMATOR [G, REAL]
		do
			create Result.make (current_container)
		end

	double_summator: EL_RESULT_SUMMATOR [G, DOUBLE]
		do
			create Result.make (current_container)
		end

feature {NONE} -- Deferred implementation

	current_container: CONTAINER [G]
		-- assign Current to Result in descendant
		deferred
		end
end