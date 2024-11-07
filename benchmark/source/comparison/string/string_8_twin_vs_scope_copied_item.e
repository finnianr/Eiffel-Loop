note
	description: "Compare 3 ways to make a temporary copy of ${STRING_8}"
	notes: "[
		Passes over 500 millisecs (in descending order)

			buffer.copied (str)           :  63288.0 times (100%)
			B. shared buffer.copied (str) :  43830.0 times (-30.7%)
			str.twin                      :  31656.0 times (-50.0%)
			A. shared buffer.copied (str) :   9925.0 times (-84.3%)
			scope.copied_item (str)       :   7005.0 times (-88.9%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-05 12:56:40 GMT (Tuesday 5th November 2024)"
	revision: "18"

class
	STRING_8_TWIN_VS_SCOPE_COPIED_ITEM

inherit
	STRING_BENCHMARK_COMPARISON

	EL_SHARED_STRING_8_BUFFER_SCOPES

	EL_SHARED_STRING_8_BUFFER_POOL

create
	make

feature -- Access

	Description: STRING = "STRING_8.twin VS scope.copied_item VS Buffer.copied"

feature -- Basic operations

	execute
		do
			compare ("compare_item", <<
				["str.twin",							 agent string_8_twin (Hexagram.English_titles)],
				["scope.copied_item (str)",		 agent scope_copied_item (Hexagram.English_titles)],
				["buffer.copied (str)",				 agent buffer_copied_item (Hexagram.English_titles)],
				["A. shared buffer.copied (str)", agent shared_buffer_copied_item_1 (Hexagram.English_titles)],
				["B. shared buffer.copied (str)", agent shared_buffer_copied_item_2 (Hexagram.English_titles)]
			>>)
		end

feature {NONE} -- replace_substring_all

	buffer_copied_item (title_list: EL_STRING_8_LIST)
		local
			str_copy: STRING
		do
			across title_list as list loop
				str_copy := Buffer.copied (list.item)
			end
		end

	scope_copied_item (title_list: EL_STRING_8_LIST)
		local
			str_copy: STRING
		do
			across title_list as list loop
				across String_8_scope as scope loop
					str_copy := scope.copied_item (list.item)
				end
			end
		end

	shared_buffer_copied_item_1 (title_list: EL_STRING_8_LIST)
		local
			str_copy: STRING
		do
			across title_list as list loop
				if attached Buffer_pool.borrowed_item as l_buffer then
					str_copy := l_buffer.copied (list.item)
					Buffer_pool.recycle (l_buffer)
				end
			end
		end

	shared_buffer_copied_item_2 (title_list: EL_STRING_8_LIST)
		local
			str_copy: STRING
		do
			across title_list as list loop
				if attached String_8_pool.borrowed_item as l_buffer then
					str_copy := l_buffer.copied (list.item)
					l_buffer.return
				end
			end
		end

	string_8_twin (title_list: EL_STRING_8_LIST)
		local
			str_copy: STRING
		do
			across title_list as list loop
				str_copy := list.item.twin
			end
		end

feature {NONE} -- Constants

	Buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

	Buffer_pool: EL_AGENT_FACTORY_POOL [EL_STRING_8_BUFFER]
		once
			create Result.make (10, agent: EL_STRING_8_BUFFER do create Result end)
		end

end