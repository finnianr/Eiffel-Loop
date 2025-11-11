note
	description: "Library class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-10 12:59:01 GMT (Monday 10th November 2025)"
	revision: "11"

class
	LIBRARY_CLASS

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
			class_occurrence_set := analyzer.class_name_set
			class_occurrence_set.prune (name)
		end

feature -- Access

	circular_dependent: detachable LIBRARY_CLASS

	class_occurrence_set: EL_HASH_SET [IMMUTABLE_STRING_8]

	name: IMMUTABLE_STRING_8

	source_path: FILE_PATH

feature -- Element change

	try_bind (candidate: LIBRARY_CLASS)
		do
			if class_occurrence_set.has (candidate.name) and then candidate.class_occurrence_set.has (name) then
				circular_dependent := candidate
				class_occurrence_set.merge (candidate.class_occurrence_set)
				class_occurrence_set.prune (name)
			end
		end

end