//---------------------------------------------------------------------------
//		E L E N A   P r o j e c t:  ELENA RT Engine
//             Linux Shared Library Declaration
//                                             (C)2024, by Aleksey Rakov
//---------------------------------------------------------------------------

#ifndef ELENART_H_INCLUDED
#define ELENART_H_INCLUDED

#if __GNUG__
#define DLL_PUBLIC __attribute__ ((visibility ("default")))
#define DLL_LOCAL  __attribute__ ((visibility ("hidden")))
#else
#define DLL_PUBLIC
#define DLL_LOCAL
#endif

extern "C"
{
   DLL_PUBLIC int PrepareVMLA(const char* configName, const char* ns, const char* path, const char* exceptionHandler);
   DLL_PUBLIC int ExecuteVMLA(const char* target, const char* arg);
   DLL_PUBLIC int FreeVMLA();
}

namespace elenavm_api
{
   constexpr auto CONFIG_NAME = "vm_client";
   constexpr auto EXCEPTION_HANDLER = "system'core_routines'critical_exception_handler";

   inline int Prepare(const char* ns, const char* path)
   {
      return PrepareVMLA(CONFIG_NAME, ns, path, EXCEPTION_HANDLER);
   }
   inline int Execute(const char* target, const char* arg)
   {
      return ExecuteVMLA(target, arg);
   }
}


#endif // ELENART_H_INCLUDED
