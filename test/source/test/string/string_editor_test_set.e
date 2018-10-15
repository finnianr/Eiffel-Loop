note
	description: "Summary description for {STRING_EDITOR_TEST_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STRING_EDITOR_TEST_SET

inherit
	EQA_TEST_SET

	EL_STRING_CONSTANTS
		undefine
			default_create
		end

feature -- Tests

	test_edit
		local
			editor: EL_ZSTRING_EDITOR
			editor_8: EL_STRING_8_EDITOR; editor_32: EL_STRING_32_EDITOR
		do
			across << Empty_string, Asterisks >> as trailing loop
				across << Empty_string, Asterisks >> as leading loop
					create editor.make (leading.item + Target.multiplied (2) + trailing.item)
					editor.for_each ("[[", "]]", agent delete_interior)
					assert ("asterisks removed", editor.target ~ leading.item + Edited_target.multiplied (2) + trailing.item)
				end
			end
		end

feature {NONE} -- Implementation

	delete_interior (start_index, end_index: INTEGER; substring: ZSTRING)
		do
			substring.remove_substring (start_index, end_index)
		end

feature {NONE} -- Constants

	Asterisks: ZSTRING
		once
			Result := "**"
		end

	Edited_target: ZSTRING
		once
			Result := "[[]]**"
		end

	Target: ZSTRING
		once
			Result := "[[**]]**"
		end

end
