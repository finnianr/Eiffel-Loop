note
	description: "Java platform specific properties"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "12"

deferred class
	JAVA_PLATFORM_I

feature {NONE} -- Initialization

	make
			--
		deferred
		ensure
			JVM_library_path_exists: JVM_library_path.exists
		end

feature -- Access

	default_jar_dir: DIR_PATH

	JVM_library_path: FILE_PATH

	JVM_library_string_path: STRING
		do
			Result := JVM_library_path.to_string
		end

	class_path_separator: CHARACTER

end