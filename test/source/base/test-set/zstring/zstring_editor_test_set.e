note
	description: "String editor test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-01 10:23:44 GMT (Monday 1st March 2021)"
	revision: "7"

class
	ZSTRING_EDITOR_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_ZSTRING_CONSTANTS

	STRING_HANDLER undefine default_create end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("for_each_balanced", agent test_for_each_balanced)
			eval.call ("for_each", agent test_for_each)
		end

feature -- Tests

	test_for_each
		local
			editor: EL_ZSTRING_EDITOR; edited: ZSTRING
		do
			edited := "[[]]**"
			across << Empty_string, Asterisks >> as trailing loop
				across << Empty_string, Asterisks >> as leading loop
					create editor.make (leading.item + Target.item (1).multiplied (2) + trailing.item)
					editor.for_each ("[[", "]]", agent delete_interior)
					assert ("asterisks removed", editor.target ~ leading.item + edited.multiplied (2) + trailing.item)
				end
			end
		end

	test_for_each_balanced
		local
			editor: EL_ZSTRING_EDITOR; edited: ZSTRING
		do
			create editor.make (Target.item (2).multiplied (2))
			editor.for_each_balanced ('[', ']', "AA", agent swap_substrings)
			edited := "[AA**[@@]]**"
			assert ("@@ and ** swapped", editor.target ~ edited.multiplied (2))

			create editor.make (Target.item (2).multiplied (2))
			editor.for_each_balanced ('[', ']', Empty_string, agent delete_interior)
			edited := "[]**"
			assert ("same strings", editor.target ~ edited.multiplied (2))

			create editor.make (Target.item (3).multiplied (2))
			editor.for_each_balanced ('[', ']', "AA", agent delete_interior)
			edited := "[AA]**"
			assert ("same strings", editor.target ~ edited.multiplied (2))
		end

feature {NONE} -- Implementation

	delete_interior (start_index, end_index: INTEGER; substring: ZSTRING)
		do
			substring.remove_substring (start_index, end_index)
		end

	swap_substrings (start_index, end_index: INTEGER; substring: ZSTRING)
		-- swap "@@" and "**"
		local
			s1, s2: ZSTRING
		do
			s1 := substring.substring (start_index, start_index + 1)
			s2 := substring.substring (start_index + 3, start_index + 4)

			substring.replace_substring (s2, start_index, start_index + 1)
			substring.replace_substring (s1, start_index + 3, start_index + 4)
		end

feature {NONE} -- Constants

	Asterisks: ZSTRING
		once
			Result := "**"
		end

	Target: ARRAY [ZSTRING]
		once
			Result := << "[[**]]**", "[AA@@[**]]**", "[AA**]**" >>
		end

end