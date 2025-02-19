note
	description: "String set initialized with shared substrings of a single line manifest string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-19 14:52:54 GMT (Wednesday 19th February 2025)"
	revision: "1"

deferred class
	EL_IMMUTABLE_STRING_SET [GENERAL -> STRING_GENERAL, IMMUTABLE -> IMMUTABLE_STRING_GENERAL]

inherit
	EL_HASH_SET [IMMUTABLE]
		rename
			has as has_immutable,
			has_key as has_immutable_key,
			make as make_sized
		end

feature {NONE} -- Initialization

	make (a_manifest_lines: GENERAL)
		do
			manifest_lines := new_shared (a_manifest_lines)
			if attached new_split_list as list then
				list.fill (manifest_lines, '%N', {EL_SIDE}.Right)
				make_equal (list.count)
				from list.start until list.after loop
					put (list.item)
					list.forth
				end
			end
		end

feature {NONE} -- Deferred

	new_shared (a_manifest: GENERAL): IMMUTABLE
		deferred
		end

	new_split_list: EL_SPLIT_READABLE_STRING_LIST [IMMUTABLE]
		deferred
		end

feature {STRING_HANDLER} -- Internal attributes

	manifest_lines: IMMUTABLE

end