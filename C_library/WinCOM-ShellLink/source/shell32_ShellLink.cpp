/* Source file: shell32_ShellLink.cpp
   Copyright Finnian Reilly 2008
   finnian at eiffel-loop dot com
*/

#include "shell32_ShellLink.h"

shell32::ShellLinkObject::ShellLinkObject()
{
	operation_result = CoCreateInstance (
		CLSID_ShellLink, NULL, CLSCTX_INPROC_SERVER,IID_IShellLink,(LPVOID*) &p_IShellLink
	);
};

shell32::ShellLinkObject::~ShellLinkObject()
{
	p_IShellLink->Release ();

};

void shell32::ShellLinkObject::set_path (LPCSTR pszFile)
{
	operation_result = p_IShellLink->SetPath (pszFile);
};


void shell32::ShellLinkObject::set_working_directory (LPCSTR pszDir)
{
	operation_result = p_IShellLink->SetWorkingDirectory (pszDir);

};

void shell32::ShellLinkObject::set_arguments (LPCSTR pszArgs)
{
	operation_result = p_IShellLink->SetArguments (pszArgs);
};

void shell32::ShellLinkObject::set_icon_location (LPCSTR pszIconPath, int iIcon)
{
	operation_result = p_IShellLink->SetIconLocation (pszIconPath, iIcon);
};

IPersistFile* shell32::ShellLinkObject::com_interface_persist_file ()
{
	IPersistFile* result;
	operation_result = p_IShellLink->QueryInterface( IID_IPersistFile, (LPVOID *) &result);
	return result;
};

bool shell32::ShellLinkObject::last_operation_succeeded (){
	return SUCCEEDED (operation_result);
}


// class PersistFile

void ole_obj::PersistFile::save (LPCWSTR pszFileName)
{
	operation_result = p_IPersistFile->Save (pszFileName, TRUE);
};

void ole_obj::PersistFile::load (LPCWSTR pszFileName)
{
	operation_result = p_IPersistFile->Load (pszFileName, 0);
};

bool ole_obj::PersistFile::last_operation_succeeded (){
	return SUCCEEDED (operation_result);
}

ole_obj::PersistFile::PersistFile(EIF_POINTER p_IPersistFile)
{
	this->p_IPersistFile = (IPersistFile*)p_IPersistFile;

};

ole_obj::PersistFile::~PersistFile()
{
	p_IPersistFile->Release ();

};

