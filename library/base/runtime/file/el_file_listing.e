note
	description: "Pure Eiffel implementation of common file and directory listing operations"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-04 18:36:32 GMT (Sunday 4th December 2022)"
	revision: "2"

class
	EL_FILE_LISTING

inherit
	ANY

	EL_MODULE_FILE_SYSTEM

	EL_SHARED_DIRECTORY

	EL_MODULE_TUPLE

feature -- Access

	new_directory_list (a_dir_path: DIR_PATH): EL_SORTABLE_ARRAYED_LIST [DIR_PATH]
		do
			Result := Directory.named (a_dir_path).recursive_directories
		end

	new_file_list (a_dir_path: DIR_PATH; pattern: READABLE_STRING_GENERAL): EL_FILE_PATH_LIST
		local
			dir: EL_DIRECTORY
		do
			dir := Directory.named (a_dir_path)
			if dir.exists then
				if pattern.same_string (Star) then
					Result := dir.recursive_files

				elseif pattern.starts_with (Star_dot) and then pattern.occurrences ('.') = 1
					and then pattern.count >= 3
				then
					Result := dir.recursive_files_with_extension (pattern.substring (3, pattern.count))

				elseif attached new_filter_predicate (pattern) as predicate then
					create Result.make_from_if (dir.recursive_files, predicate)

				else
					Result := dir.recursive_files
				end
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Implementation

	base_ends_with (path: FILE_PATH; str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := path.base.ends_with_general (str)
		end

	base_has_substring (path: FILE_PATH; str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := path.base.has_substring (str)
		end

	base_starts_with (path: FILE_PATH; str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := path.base.starts_with_general (str)
		end

	new_filter_predicate (pattern: READABLE_STRING_GENERAL): detachable PREDICATE [FILE_PATH]
		do
			if pattern.count >= 3
				and then pattern.starts_with (star) and pattern.ends_with (Star)
			then
				Result := agent base_has_substring (?, pattern.substring (2, pattern.count - 1))

			elseif pattern.count >= 2 and then pattern.starts_with (Star) then
				Result := agent base_ends_with (?, pattern.substring (2, pattern.count))

			elseif pattern.count >= 2 and then pattern.ends_with (Star) then
				Result := agent base_starts_with (?, pattern.substring (1, pattern.count - 1))
			end
		end

feature {NONE} -- Constants

	Star_dot: STRING = "*."

	Star: STRING = "*"

end