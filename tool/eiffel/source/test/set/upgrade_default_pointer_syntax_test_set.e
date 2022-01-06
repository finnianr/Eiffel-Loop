note
	description: "Test class [$source UPGRADE_DEFAULT_POINTER_SYNTAX_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-06 17:23:49 GMT (Thursday 6th January 2022)"
	revision: "1"

class
	UPGRADE_DEFAULT_POINTER_SYNTAX_TEST_SET

inherit
	COPIED_SOURCES_TEST_SET

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("syntax_change", agent test_syntax_change)
		end

feature -- Tests

	test_syntax_change
		local
			command: UPGRADE_DEFAULT_POINTER_SYNTAX_COMMAND
			md5_digest: STRING
		do
			create command.make (Manifest_path)
			command.execute

			across file_list as path loop
				if path.item.base_sans_extension.same_string ("el_application_mutex_impl") then
					md5_digest := Digest.md5_file (path.item).to_base_64_string
					assert ("correct change", md5_digest ~ "tD/I28G5sVUFFyGKMJ6Lew==")
				end
			end
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := "test-data/sources/latin-1/kernel"
		end

end