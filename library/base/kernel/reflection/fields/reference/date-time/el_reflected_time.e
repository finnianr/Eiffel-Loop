note
	description: "Reflected field of type [$source TIME]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-23 13:45:45 GMT (Friday 23rd December 2022)"
	revision: "22"

class
	EL_REFLECTED_TIME

inherit
	EL_REFLECTED_TEMPORAL [TIME]
		rename
			valid_string as valid_format
		redefine
			new_factory, reset, set_from_memory, set_from_string, write, valid_format
		end

create
	make

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			if attached value (a_object) as time then
				time.copy (time.origin)
			end
		end

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as time then
				time.make_by_compact_time (memory.read_integer_32)
				time.set_fractionals (0)
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if attached value (a_object) as time then
				time.make_from_string_default (Buffer_8.copied_general (string))
			end
		end

	write (a_object: EL_REFLECTIVE; writable: EL_WRITABLE)
		do
			if attached value (a_object) as time then
				writable.write_integer_32 (time.compact_time)
			end
		end

feature -- Contract Support

	valid_format (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached value (a_object) as time then
				Result := time.time_valid (Buffer_8.copied_general (string), time.default_format_string)
			end
		end

feature {NONE} -- Implementation

	new_factory: detachable EL_FACTORY [TIME]
		do
			if attached {EL_FACTORY [TIME]} Time_factory.new_item_factory (type_id) as f then
				Result := f
			else
				Result := Precursor
			end
		end

	upgraded (time: TIME): EL_TIME
		-- upgrade `TIME' to `EL_TIME'
		do
			Result := EL_time
			Result.make_by_fine_seconds (time.fine_seconds)
		end

feature {NONE} -- Constants

	EL_time: EL_TIME
		once
			create Result.make (0, 0, 0)
		end

end