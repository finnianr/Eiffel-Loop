note
	description: "Compare various ways of concatenating strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "14"

class
	STRING_CONCATENATION_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

	EL_SHARED_STRING_8_BUFFER_SCOPES

create
	make

feature -- Access

	Description: STRING = "STRING_8: concatenation methods"

feature -- Basic operations

	execute
		do
			compare (Description, <<
				["append to empty result",			 agent result_append],
				["append to once buffer",			 agent buffer_append],
				["append to across scope buffer", agent append_with_across_scope]
			>>)
		end

feature {NONE} -- String append variations

	append_with_across_scope: STRING
		do
			across String_8_scope as scope loop
				if attached scope.item as joined then
					across Hexagram.English_titles as title loop
						joined.append (title.item)
					end
					Result := joined.twin
				end
			end
		end

	buffer_append: STRING
		do
			if attached Once_buffer.empty as buffer then
				across Hexagram.English_titles as title loop
					buffer.append (title.item)
				end
				Result := buffer.twin
			end
		end

	result_append: STRING
		do
			create Result.make_empty
			across Hexagram.English_titles as title loop
				Result.append (title.item)
			end
			Result.trim
		end

feature {NONE} -- Constants

	Once_buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

end