note
	description: "Compare checking if identifier is attached vs checking if boolean is true"
	notes: "[
		Passes over 1000 millisecs (in descending order)

			Test boolean    : 26323.0 times (100%)
			Test attachment : 23101.0 times (-12.2%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-24 10:39:38 GMT (Wednesday 24th May 2023)"
	revision: "9"

class
	ATTACH_TEST_VS_BOOLEAN_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "Call in loop depends on boolean or attachment"

feature -- Basic operations

	execute
		do
			compare ("Boolean test VS attachment test", <<
				["Test boolean", agent test_boolean],
				["Test attachment", agent test_attachment]
			>>)
		end

feature {NONE} -- Implemenatation

	test_boolean
		local
			i: INTEGER; n: INTEGER_REF
			increment: BOOLEAN
		do
			create n
			increment := True
			from i := 1 until i > 10_000 loop
				if increment then
					n.set_item (n.item + 1)
				end
				i := i + 1
			end
		end

	test_attachment
		local
			i: INTEGER; integer: detachable INTEGER_REF
		do
			create integer
			from i := 1 until i > 10_000 loop
				if attached integer as n then
					n.set_item (n.item + 1)
				end
				i := i + 1
			end
		end
end