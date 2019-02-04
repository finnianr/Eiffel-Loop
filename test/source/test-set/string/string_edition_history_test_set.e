note
	description: "Summary description for {STRING_EDITION_HISTORY_TEST_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STRING_EDITION_HISTORY_TEST_SET

inherit
	EQA_TEST_SET

feature -- Tests

	test_zstring_editions
		local
			history: EL_ZSTRING_EDITION_HISTORY
			string: ZSTRING
		do
			create history.make (20)
			across Editions_list as edition loop
				history.extend (edition.item)
			end

			undo_zstring_changes (history)

			across Editions_list as edition loop
				history.redo
				string := edition.item
				assert ("same string", history.string ~ string)
			end

			undo_zstring_changes (history)
		end


	test_string_8_editions
		local
			history: EL_STRING_8_EDITION_HISTORY
			string: STRING
		do
			create history.make (20)
			across Editions_list as edition loop
				history.extend (edition.item)
			end

			undo_string_8_changes (history)

			across Editions_list as edition loop
				history.redo
				string := edition.item
				assert ("same string", history.string ~ string)
			end

			undo_string_8_changes (history)
		end

feature {NONE} -- Implementation

	undo_string_8_changes (history: EL_STRING_8_EDITION_HISTORY)
		local
			string: STRING
		do
			across Editions_list.new_cursor.reversed as edition loop
				string := edition.item
				assert ("same string", history.string ~ string)
				history.undo
			end
			assert ("empty string", history.string.is_empty)
		end

	undo_zstring_changes (history: EL_ZSTRING_EDITION_HISTORY)
		local
			string: ZSTRING
		do
			across Editions_list.new_cursor.reversed as edition loop
				string := edition.item
				assert ("same string", history.string ~ string)
				history.undo
			end
			assert ("empty string", history.string.is_empty)
		end

feature {NONE} -- Constants

	Editions: STRING = "[
		aaBBcc
		aaBcc
		aacc
		aaDDcc
		DDcc
		DDc
		aDDc
		aBBc
		AAAA
	]"
	Editions_list: LIST [STRING]
		once
			Result := Editions.split ('%N')
		end

end
