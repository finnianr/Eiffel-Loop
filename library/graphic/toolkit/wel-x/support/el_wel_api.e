note
	description: "Summary description for {EL_WEL_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-07-09 8:14:41 GMT (Thursday 9th July 2015)"
	revision: "3"

class
	EL_WEL_API

feature -- Constants

	max_path: INTEGER
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
