/* Source file: shell32_ShellLink.h
   Copyright Finnian Reilly 2008
   finnian at eiffel-loop dot com
*/

#ifndef _WCOM_SHELL32_SHELL_LINK_H_
#define _WCOM_SHELL32_SHELL_LINK_H_

#include "shlobj.h"

#include "eif_eiffel.h"

namespace shell32
{
class ShellLinkObject
{
public:
	ShellLinkObject ();
	virtual ~ShellLinkObject ();

	void set_path (LPCSTR pszFile);

	void set_working_directory (LPCSTR pszDir);

	void set_arguments (LPCSTR pszArgs);

	void set_icon_location (LPCSTR pszIconPath, int iIcon);

	IPersistFile* com_interface_persist_file ();

	bool last_operation_succeeded ();

private:

	HRESULT operation_result;

	IShellLink* p_IShellLink;

};
}

namespace ole_obj
{
class PersistFile {

public:
	PersistFile (EIF_POINTER p_IPersistFile);
	virtual ~PersistFile ();

	void save (LPCWSTR pszFileName);

	void load (LPCWSTR pszFileName);

	bool last_operation_succeeded ();

private:

	HRESULT operation_result;

	IPersistFile* p_IPersistFile;

};
}

#endif
