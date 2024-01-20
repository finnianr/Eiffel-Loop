note
	description: "[
		Test set for class ${PYXIS_EIFFEL_CONFIG} and ${SCONS_PROJECT_PY_CONFIG}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "12"

class
	PYXIS_EIFFEL_CONFIG_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	EL_MODULE_BUILD_INFO

	EL_SHARED_SOFTWARE_VERSION

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["scons_initialization", agent test_scons_initialization],
				["version_bump", agent test_version_bump],
				["version_reading", agent test_version_reading]
			>>)
		end

feature -- Tests

	test_scons_initialization
		local
			scons: SCONS_PROJECT_PY_CONFIG; config: PYXIS_EIFFEL_CONFIG
		do
			create scons.make_from_file (file_list [2])
			assert ("ecf OK", scons.ecf.same_string ("eiffel.ecf"))
			assert ("build_info_path OK", scons.build_info_path ~ file_list [3].relative_path (Work_area_dir))

			create config.make_scons (scons)
			assert ("same version", config.system.version.compact_version = Build_info.version_number)
		end

	test_version_bump
		-- PYXIS_EIFFEL_CONFIG_TEST_SET.test_version_bump
		local
			config: PYXIS_EIFFEL_CONFIG; new_version: EL_SOFTWARE_VERSION
		do
			if attached file_list.first_path as path then
				create config.make (path)
				lio.put_labeled_string ("Version", config.system.version.string)
				lio.put_new_line
				if attached config.system.version as version then
					version.bump_major
					config.set_version (version)

					create config.make (path)
					lio.put_labeled_string ("Version", config.system.version.string)
					lio.put_new_line

					new_version := Software_version.twin
					new_version.bump_major

					assert ("same version", config.system.version.compact_version = new_version.compact_version)
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
				lio.put_labeled_string ("Version", config.system.version.string)
				lio.put_new_line
				if attached config.system as version then
					assert ("same version", version.version.compact_version = Build_info.version_number)
					assert ("company OK", version.company.same_string (Build_info.company))
					assert ("product OK", version.product.same_string (Build_info.product))
				end
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<<
				"eiffel.pecf", "project.py", "source/root/build_info.e"
			>>)
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			create Result
		end
end