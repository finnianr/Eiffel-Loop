note
	description: "Test class [$source CODEC_GENERATOR]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-10 16:11:42 GMT (Friday 10th February 2023)"
	revision: "9"

class
	CODEC_GENERATOR_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

feature -- Basic operations

	do_all (evaluator: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			evaluator.call ("generation", agent test_generation)
		end

feature -- Tests

	test_generation
		local
			command: CODEC_GENERATOR; count: INTEGER
		do
			create command.make ("test-data/sources/C/decoder.c", "doc/zcodec/template.evol")
			command.execute
			lio.put_new_line
			across OS.file_list (Work_area_dir, "*.e") as path loop
				if attached path.item.base_name.split_list ('_')[4] as id then
					lio.put_labeled_string ("Comparing content digest for id", id)
					lio.put_new_line
					if Digest_table.has_key (id.to_integer) then
						assert ("has BOM", File.has_utf_8_bom (path.item))
						assert_same_digest (path.item, Digest_table.found_item)
						count := count + 1
					else
						assert ("Source has digest", False)
					end
				end
			end
			assert ("all codecs checked", count = Digest_table.count)
		end

feature {NONE} -- Constants

	Digest_table: EL_HASH_TABLE [STRING, INTEGER]
		once
			create Result.make (<<
				[11, "JPRXGeJq0XmUlSs44SufLQ=="],
				[15, "dGkEUQs4ARjX8c/3cqy+MA=="],
				[2, "evDerblysNkTUZ9Kt3MlJQ=="],
				[6, "+rBIvQqv5fyKNSVfHwnvXA=="]
			>>)
		end

end