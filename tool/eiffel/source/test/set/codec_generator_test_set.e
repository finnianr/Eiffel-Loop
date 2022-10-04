note
	description: "Test class [$source CODEC_GENERATOR]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-04 8:55:34 GMT (Tuesday 4th October 2022)"
	revision: "4"

class
	CODEC_GENERATOR_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

feature -- Basic operations

	do_all (evaluator: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			evaluator.call ("generation", agent test_generation)
		end

feature -- Tests

	test_generation
		local
			command: CODEC_GENERATOR
		do
			create command.make (Generation_dir + "test-decoder.c", Generation_dir + "template.evol")
			command.execute
			across OS.file_list (Generation_dir, "*.e") as path loop
				if Digest_table.has_key (path.item.base_sans_extension) then
					assert_same_digest (path.item, Digest_table.found_item)
				else
					assert ("Source has digest", False)
				end
			end
		end

feature {NONE} -- Implementation

	source_dir: DIR_PATH
		do
			Result := "test-data/codec-generation"
		end

feature {NONE} -- Constants

	Digest_table: EL_HASH_TABLE [STRING, STRING]
		once
			create Result.make (<<
				["el_iso_8859_11_zcodec", "AFdduU6rk+dVcaDM31gF1w=="],
				["el_iso_8859_15_zcodec", "CqV3Oaxh4j6Yy6fswHHulw=="],
				["el_iso_8859_2_zcodec", "qc2+u7RQkKxCt5lLHlVe0g=="],
				["el_iso_8859_9_zcodec", "E3VBhccDZ54Uu/lN8tDLuw=="]
			>>)
		end

	Generation_dir: DIR_PATH
		do
			Result := Work_area_dir #+ source_dir.base
		end
end