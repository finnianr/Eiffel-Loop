note
	description: "Compare checking if identifier is attached vs checking if boolean is true"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "10"

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