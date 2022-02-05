note
	description: "[
		Insert callbacks for implementation of `do_all' from test set class inheriting [$source EL_EQA_TEST_SET]
		
		For example:
		
			do_all (eval: EL_EQA_TEST_EVALUATOR)
				-- evaluate all tests
				do
					eval.call ("file_editing", agent test_file_editing)
				end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 9:45:02 GMT (Saturday 5th February 2022)"
	revision: "3"

class
	EQA_TEST_EVALUATION_CALLBACK_FEATURE

inherit
	CLASS_FEATURE
		rename
			make as make_feature
		end

create
	make

feature {NONE} -- Initialization

	make (a_feature_group_list: like feature_group_list; line: ZSTRING)
		do
			feature_group_list := a_feature_group_list
			make_feature (line)
		end

feature -- Element change

	expand_shorthand
		local
			group_name, line, eval, test_name: ZSTRING
			do_end_list: EL_ZSTRING_LIST
		do
			line := lines.first
			eval := lines.first.substring_between_general ("(", ":", 1)

			create do_end_list.make (20)
			across feature_group_list as group loop
				group_name := group.item.name.as_lower
				if across Test_endings as ending some group_name.ends_with (ending.item) end then
					across group.item.features as l_feature loop
						if l_feature.item.name.starts_with (Test_prefix) then
							test_name := l_feature.item.name.substring_end (Test_prefix.count + 1)
							do_end_list.extend (Eval_template #$ [eval, test_name, test_name])
						end
					end
				end
			end
			if not do_end_list.is_empty then
				do_end_list.indent (1)
				do_end_list.put_front ("do")
				do_end_list.extend ("end")
				do_end_list.indent (2)

				from lines.start until lines.item.ends_with (Keyword.do_) or else lines.after loop
					lines.forth
				end
				if not lines.after then
					lines.remove_tail (lines.count - (lines.index - 1))
				end
				lines.append (do_end_list)
				lines.extend (Empty_string)
			end
		end

feature {NONE} -- Internal attributes

	feature_group_list: FEATURE_GROUP_LIST

feature {NONE} -- Constants

	Test_endings: ARRAY [ZSTRING]
		once
			Result := << "test", "tests" >>
		end

	Test_prefix: ZSTRING
		once
			Result := "test_"
		end

	Eval_template: ZSTRING
		once
			Result := "%S.call (%"%S%", agent test_%S)"
		end
end