note
	description: "Wel api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-03 11:28:54 GMT (Wednesday 3rd January 2024)"
	revision: "7"

class
	EL_WEL_API

feature -- Constants

	max_path_count: INTEGER
			-- Maximum number of characters in path
		external
			"C [macro <limits.h>]"
		alias
			"MAX_PATH"
		end

	get_current_theme_name (name: POINTER; max_name_count: INTEGER): INTEGER
			--	HRESULT GetCurrentThemeName(
			--	 _Out_ LPWSTR pszThemeFileName, _In_  int    dwMaxNameChars,
			--	 _Out_ LPWSTR pszColorBuff,	_In_  int    cchMaxColorChars,
			--	 _Out_ LPWSTR pszSizeBuff, _In_  int    cchMaxSizeChars
			-- );
		external
			"C inline use <Uxtheme.h>"
		alias
			"GetCurrentThemeName ((LPWSTR)$name, (int)$max_name_count, NULL, 0, NULL, 0)"
		end

feature -- Element change

	frozen add_font_resource (file_path: POINTER): INTEGER
			-- int AddFontResource(_In_  LPCTSTR lpszFilename);
		external
			"C signature (LPCTSTR): EIF_INTEGER use <Windows.h>"
		alias
			"AddFontResource"
		end
end