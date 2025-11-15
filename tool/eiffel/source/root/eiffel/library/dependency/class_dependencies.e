note
	description: "Type dependencies for a named class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-15 8:58:17 GMT (Saturday 15th November 2025)"
	revision: "12"

class
	CLASS_DEPENDENCIES

inherit
	ANY

	EL_MODULE_FILE

create
	make

feature {NONE} -- Initialization

	make (a_source_path: FILE_PATH)
		local
			analyzer: CLASS_NAME_OCCURRENCE_ANALYZER
		do
			source_path := a_source_path
			name := a_source_path.base_name.as_upper.to_shared_immutable_8
			create analyzer.make_from_file (a_source_path)
			dependency_set := analyzer.class_name_set
			dependency_set.prune (name)
		end

feature -- Access

	circular_dependent: detachable CLASS_DEPENDENCIES

	dependency_set: EL_HASH_SET [IMMUTABLE_STRING_8]
		-- set of classes on which class with `name' depends

	name: IMMUTABLE_STRING_8

	source_path: FILE_PATH

feature -- Element change

	try_bind (candidate: CLASS_DEPENDENCIES)
		do
			if dependency_set.has (candidate.name) and then candidate.dependency_set.has (name) then
				circular_dependent := candidate
				dependency_set.merge (candidate.dependency_set)
				dependency_set.prune (name)
			end
		end

end