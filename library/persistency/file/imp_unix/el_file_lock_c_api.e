note
	description: "Unix file C API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-19 11:27:13 GMT (Monday 19th August 2024)"
	revision: "15"

class
	EL_FILE_LOCK_C_API

inherit
	EL_C_API

	EL_UNIX_IMPLEMENTATION

feature {NONE} -- C Externals

	frozen c_create_write_only (a_path: POINTER; a_error: TYPED_POINTER [NATURAL]): INTEGER
		require
			not_null_pointer: is_attached (a_path)
		external
			"C inline use <unistd.h>"
		alias
			"[
				int result = open ((const char *)$a_path, O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR);
				if (result < 0) *((int*)$a_error) = errno;
				return result;
			]"
		end

	frozen c_aquire_lock (descriptor: INTEGER; fl: POINTER): INTEGER
		require
			valid_descriptor: descriptor /= -1
			not_null_pointer: is_attached (fl)
		external
			"C inline use <fcntl.h>"
		alias
			"fcntl((int)$descriptor, F_SETLK, (struct flock*)$fl)"
		end

	frozen c_close (descriptor: INTEGER): INTEGER
		require
			valid_descriptor: descriptor /= -1
		external
			"C (int): EIF_INTEGER | <unistd.h>"
		alias
			"close"
		end

	frozen c_file_truncate (descriptor, count: INTEGER): INTEGER
			-- int ftruncate(int fildes, off_t length);
			-- The ftruncate() function causes the regular file referenced by fildes to have a size of `count' bytes.
			-- Upon successful completion, ftruncate() and truncate() return 0.
			-- Otherwise a -1 is returned, and errno is set to indicate the error.

		require
			valid_descriptor: descriptor /= -1
		external
			"C (int, off_t): EIF_INTEGER | <unistd.h>"
		alias
			"ftruncate"
		end

	frozen c_write (descriptor: INTEGER; data: POINTER; byte_count: INTEGER): INTEGER
		-- ssize_t write(int fildes, const void *buf, size_t nbyte);

		-- The write() function attempts to write nbyte bytes from the buffer pointed to by buf to the file
		-- associated with the open file descriptor, fildes. If nbyte is 0, write() will return 0 and have no
		-- other results if the file is a regular file; otherwise, the results are unspecified.
		-- https://pubs.opengroup.org/onlinepubs/7908799/xsh/write.html

		external
			"C (int, const void *, size_t): EIF_INTEGER | <unistd.h>"
		alias
			"write"
		end

feature {NONE} -- C struct flock

	frozen c_flock_struct_size: INTEGER
		external
			"C [macro <fcntl.h>]"
		alias
			"sizeof(struct flock)"
		end

	frozen c_set_flock_type (p: POINTER; type: INTEGER)
			--
		external
			"C [struct <fcntl.h>] (struct flock, int)"
		alias
			"l_type"
		end

	frozen c_set_flock_whence (p: POINTER; v: INTEGER)
			--
		external
			"C [struct <fcntl.h>] (struct flock, int)"
		alias
			"l_whence"
		end

	frozen c_set_flock_start (p: POINTER; v: INTEGER)
			--
		external
			"C [struct <fcntl.h>] (struct flock, int)"
		alias
			"l_start"
		end

	frozen c_set_flock_length (p: POINTER; v: INTEGER)
			--
		external
			"C [struct <fcntl.h>] (struct flock, int)"
		alias
			"l_len"
		end

feature {NONE} -- C macro constants

	frozen c_file_write_lock: INTEGER
		external
			"C [macro <fcntl.h>]"
		alias
			"F_WRLCK"
		end

	frozen c_file_unlock: INTEGER
		external
			"C [macro <fcntl.h>]"
		alias
			"F_UNLCK"
		end

	frozen c_seek_set: INTEGER
		external
			"C [macro <fcntl.h>]"
		alias
			"SEEK_SET"
		end

end