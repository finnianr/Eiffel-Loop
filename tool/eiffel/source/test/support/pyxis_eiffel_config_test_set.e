note
	description: "[
		Test set for class [$source SOFTWARE_INFO]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-03 15:43:18 GMT (Friday 3rd March 2023)"
	revision: "8"

class
	PYXIS_EIFFEL_CONFIG_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	EL_MODULE_BUILD_INFO

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("version_reading", agent test_version_reading)
			eval.call ("version_bump", agent test_version_bump)
		end

feature -- Tests

	test_version_bump
		-- PYXIS_EIFFEL_CONFIG_TEST_SET.test_version_bump
		local
			config: PYXIS_EIFFEL_CONFIG; new_version: EL_SOFTWARE_VERSION
		do
			if attached file_list.first_path as path then
				create config.make (path)
				lio.put_labeled_string ("Version", config.system.software.string)
				lio.put_new_line
				if attached config.system.software as version then
					version.bump_major
					config.set_version (version)

					create config.make (path)
					lio.put_labeled_string ("Version", config.system.software.string)
					lio.put_new_line

					new_version := Build_info.version.twin
					new_version.bump_major
					
					assert ("same version", config.system.software.compact_version = new_version.compact_version)
				end
			end
		end

	test_version_reading
		-- PYXIS_EIFFEL_CONFIG_TEST_SET.test_version_reading
		local
			config: PYXIS_EIFFEL_CONFIG
		do
			if attached file_list.first_path as path then
				create config.make (path)
				lio.put_labeled_string ("Version", config.system.software.string)
				lio.put_new_line
				if attached config.system as version then
					assert ("same version", version.software.compact_version = Build_info.version_number)
					assert ("company OK", version.company.same_string (Build_info.company))
					assert ("product OK", version.product.same_string (Build_info.product))
				end
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<<
				"eiffel.pecf"
			>>)
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			create Result
		end
end