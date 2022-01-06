note
	description: "Test class [$source CODEC_GENERATOR]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-06 14:17:17 GMT (Thursday 6th January 2022)"
	revision: "1"

class
	CODEC_GENERATOR_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

feature -- Basic operations

	do_all (evaluator: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			evaluator.call ("generation", agent test_generation)
		end

feature -- Tests

	test_generation
		local
			command: CODEC_GENERATOR; digest_string: STRING
		do
			create command.make (Generation_dir + "test-decoder.c", Generation_dir + "template.evol")
			command.execute
			across OS.file_list (Generation_dir, "*.e") as path loop
				digest_string := Digest.md5_file (path.item).to_base_64_string
--				lio.put_labeled_string ("Digest " + path.item.base, digest_string)
--				lio.put_new_line
				if Digest_table.has_key (path.item.base_sans_extension) then
					assert ("same digest", Digest_table.found_item ~ digest_string)
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