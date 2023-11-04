note
	description: "Shared file that can be locked for exclusive writing operation"
	notes: "[
		Tested with [$source MUTEX_FILE_TEST_SET] but revealed a problem that the file count
		is not changing when you overwrite with new content. So something not working.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-04 18:44:20 GMT (Saturday 4th November 2023)"
	revision: "2"

class
	EL_PLAIN_TEXT_MUTEX_FILE

inherit
	PLAIN_TEXT_FILE
		rename
			descriptor as new_descriptor -- from `file_pointer'
		export
			{NONE} all
			{ANY} is_closed, put_string, put_new_line
		redefine
			close, open_write, make_with_name
		end

	EL_FILE_LOCK_C_API

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make_with_name

feature {NONE} -- Initialization

	make_with_name (fn: READABLE_STRING_GENERAL)
		do
			Precursor (fn)
			descriptor := c_create_write_only (internal_name_pointer.item)
			create mutex.make_write (descriptor)
		end

feature -- Status query

	is_lockable: BOOLEAN
		do
			Result := descriptor.to_boolean
		end

	is_locked: BOOLEAN
		do
			Result := mutex.is_locked
		end

feature -- Status change

	close
		require else
			unlocked: not is_locked
		do
			if descriptor.to_boolean and then c_close (descriptor) = 0 then
				mode := Closed_file
				file_pointer := default_pointer; descriptor := 0
			end
		ensure then
			not_lockable: not is_lockable
		end

	try_until_locked (interval_ms: INTEGER)
		-- keep trying to mutex with `interval_ms' millisecs wait between attempts
		do
			mutex.try_until_locked (interval_ms)
		end

	try_lock
		require
			is_lockable: is_lockable
		do
			mutex.try_lock
		end

	unlock
		require
			locked: is_locked
			is_lockable: is_lockable
		do
			mutex.unlock
		ensure
			unlocked: not is_locked
		end

feature -- Status setting

	open_write
		require else
			locked: is_locked
		do
			file_pointer := c_open_with_descriptor (descriptor, Write_mode.base_address)
			mode := Write_file
		end

feature {NONE} -- Internal attributes

	descriptor: INTEGER

	mutex: EL_FILE_LOCK

feature {NONE} -- Constants

	Write_mode: EL_C_STRING_8
		once
			Result := "w"
		end

end