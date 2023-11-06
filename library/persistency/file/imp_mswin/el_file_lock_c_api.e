note
	description: "File C API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-06 8:48:59 GMT (Monday 6th November 2023)"
	revision: "12"

class
	EL_FILE_LOCK_C_API

inherit
	EL_C_API_ROUTINES

feature {NONE} -- C Externals

	frozen c_create_write_only (path: POINTER): INTEGER
		do
		end

	frozen c_aquire_lock (f_descriptor: INTEGER; fl: POINTER): INTEGER
		do
		end

	frozen c_close (descriptor: INTEGER): INTEGER
		do
		end

	frozen c_file_truncate (descriptor, count: INTEGER): INTEGER
			-- int ftruncate(int fildes, off_t length);
			-- The ftruncate() function causes the regular file referenced by fildes to have a size of `count' bytes.
			-- Upon successful completion, ftruncate() and truncate() return 0.
			-- Otherwise a -1 is returned, and errno is set to indicate the error.
		do
		end

	frozen c_write (descriptor: INTEGER; data: POINTER; byte_count: INTEGER): INTEGER
		-- ssize_t write(int fildes, const void *buf, size_t nbyte);

		-- The write() function attempts to write nbyte bytes from the buffer pointed to by buf to the file
		-- associated with the open file descriptor, fildes. If nbyte is 0, write() will return 0 and have no
		-- other results if the file is a regular file; otherwise, the results are unspecified.
		-- https://pubs.opengroup.org/onlinepubs/7908799/xsh/write.html
		do
		end

feature {NONE} -- C struct flock

	frozen c_flock_struct_size: INTEGER
		do
		end


	frozen c_set_flock_type (p: POINTER; type: INTEGER)
			--
		do
		end

	frozen c_set_flock_whence (p: POINTER; v: INTEGER)
			--
		do
		end


	frozen c_set_flock_start (p: POINTER; v: INTEGER)
			--
		do
		end


	frozen c_set_flock_length (p: POINTER; v: INTEGER)
			--
		do
		end


feature {NONE} -- C macro constants

	frozen c_file_write_lock: INTEGER
		do
		end


	frozen c_file_unlock: INTEGER
		do
		end


	frozen c_seek_set: INTEGER
		do
		end


end