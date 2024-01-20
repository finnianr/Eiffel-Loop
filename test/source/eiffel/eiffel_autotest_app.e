note
	description: "Test core concepts and behaviour of basic Eiffel code and libraries"
	notes: "[
		Command option: `-eiffel_autotest'

		**Test Sets**

			${AGENT_TEST_SET}
			${DATE_TIME_2_TEST_SET}
			${EIFFEL_TEST_SET}
			${FILE_TEST_SET}
			${NUMERIC_TEST_SET}
			${STRUCTURE_TEST_SET}
			${TEXT_DATA_TEST_SET}
			${TUPLE_TEST_SET}
			${TYPE_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	EIFFEL_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [
		AGENT_TEST_SET,
		DATE_TIME_2_TEST_SET,
		EIFFEL_TEST_SET,
		FILE_TEST_SET,
		NUMERIC_TEST_SET,
		STRUCTURE_TEST_SET,
		TEXT_DATA_TEST_SET,
		TUPLE_TEST_SET,
		TYPE_TEST_SET
	]

create
	make

feature -- Syntax testing

	my_routine
		local
			a1, a2, a3: INTEGER_REF
			b1, b2: INTEGER
		do
			if a1 = a2 then
				-- something
			end
			if b1 = b2 then
				-- something
			end
			if a1 = b2 then
			end
		end

	ref_equal_to_expanded
		local
			a: INTEGER_REF; b: INTEGER
			bool: BOOLEAN
		do
			a := 1; b := 1
			bool := a = b
			bool := a ~ b
		end
end