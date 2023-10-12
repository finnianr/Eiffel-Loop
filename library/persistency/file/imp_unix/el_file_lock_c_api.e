note
	description: "File C API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_FILE_LOCK_C_API

inherit
	EL_C_API_ROUTINES

feature {NONE} -- C Externals

	frozen c_create_write_only (path: POINTER): INTEGER
		require
			not_null_pointer: is_attached (path)
		external
			"C inline use <fcntl.h>"
		alias
			"open ((const char *)$path, O_WRONLY|O_CREAT, 0666)"
		end

	frozen c_aquire_lock (f_descriptor: INTEGER; fl: POINTER): INTEGER
		require
			valid_descriptor: f_descriptor /= -1
			not_null_pointer: is_attached (fl)
		external
			"C inline use <fcntl.h>"
		alias
			"fcntl((int)$f_descriptor, F_SETLK, (struct flock*)$fl)"
		end

	frozen c_close (f_descriptor: INTEGER): INTEGER
		require
			valid_descriptor: f_descriptor /= -1
		external
			"C (int): EIF_INTEGER | <unistd.h>"
		alias
			"close"
		end

	frozen c_open_with_descriptor (a_descriptor: INTEGER; mode: POINTER): POINTER
			-- FILE *fdopen(int fildes, const char *mode)
		external
			"C (int, const char *): EIF_POINTER | <stdio.h>"
		alias
			"fdopen"
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

feature {NONE} -- Constants

	File_write_lock: INTEGER
		once
			Result := c_file_write_lock
		end

	File_unlock: INTEGER
		once
			Result := c_file_unlock
		end

	Seek_set: INTEGER
		once
			Result := c_seek_set
		end
end
