note
	description: "Basic metrics for Eiffel class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-11 11:01:16 GMT (Tuesday 11th June 2024)"
	revision: "1"

deferred class
	EIFFEL_SOURCE_METRICS

feature -- Measurement

	byte_count: INTEGER
		deferred
		end

	external_routine_count: INTEGER

	identifier_count: INTEGER

	keyword_count: INTEGER

	metrics: SPECIAL [INTEGER]
		-- metrics array in alphabetical order of name
		do
			create Result.make_filled (byte_count, metric_count)
			Result [1] := external_routine_count
			Result [2] := identifier_count
			Result [3] := keyword_count
			Result [4] := routine_count
		end

	routine_count: INTEGER

feature -- Constants

	Metric_count: INTEGER = 5

end