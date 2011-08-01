dnl Function to test if a certain feature was enabled
AC_DEFUN([COMMON_ARG_ENABLE],
 [AC_ARG_ENABLE(
  [$1],
  [AS_HELP_STRING(
   [--enable-$1],
   [$3 [default is $4]])],
  [ac_cv_enable_$2=$enableval],
  [ac_cv_enable_$2=$4])dnl
  AC_CACHE_CHECK(
   [whether to enable $3],
   [ac_cv_enable_$2],
   [ac_cv_enable_$2=$4])dnl
 ])

dnl Function to test if the location of a certain feature was provided
AC_DEFUN([COMMON_ARG_WITH],
 [AC_ARG_WITH(
  [$1],
  [AS_HELP_STRING(
   [--with-$1=[$5]],
   [$3 [default is $4]])],
  [ac_cv_with_$2=$withval],
  [ac_cv_with_$2=$4])dnl
  AC_CACHE_CHECK(
   [whether to use $3],
   [ac_cv_with_$2],
   [ac_cv_with_$2=$4])dnl
 ])

dnl Function to detect whether WINAPI support should be enabled
AC_DEFUN([AC_CHECK_WINAPI],
 [AS_IF(
  [test "x$ac_cv_enable_winapi" = xauto-detect],
  [ac_cv_target_string="$target";

  AS_IF(
   [test "x$ac_cv_target_string" = x],
   [ac_cv_target_string="$build"])

  AS_CASE(
   [$ac_cv_target_string],
   [*mingw*],[AC_MSG_NOTICE(
              [Detected MinGW enabling WINAPI support for cross-compilation])
             ac_cv_enable_winapi=yes],
   [*],[ac_cv_enable_winapi=no])
  ])

 AS_IF(
  [test "x$ac_cv_enable_winapi" = xyes],
  [ac_cv_enable_wide_character_type=yes])
 ])

dnl Function to detect whether printf conversion specifier "%jd" is available
AC_DEFUN([AC_CHECK_FUNC_PRINTF_JD],
 [AC_MSG_CHECKING(
  [whether printf supports the conversion specifier "%jd"])

 SAVE_CFLAGS="$CFLAGS"
 CFLAGS="$CFLAGS -Wall -Werror"
 AC_LANG_PUSH(C)

 dnl First try to see if compilation and linkage without a parameter succeeds
 AC_LINK_IFELSE(
  [AC_LANG_PROGRAM(
   [[#include <stdio.h>]],
   [[printf( "%jd" ); ]] )],
  [ac_cv_cv_have_printf_jd=no],
  [ac_cv_cv_have_printf_jd=yes])

 dnl Second try to see if compilation and linkage with a parameter succeeds
 AS_IF(
  [test "x$ac_cv_cv_have_printf_jd" = xyes],
  [AC_LINK_IFELSE(
   [AC_LANG_PROGRAM(
    [[#include <sys/types.h>
#include <stdio.h>]],
    [[printf( "%jd", (off_t) 10 ); ]] )],
    [ac_cv_cv_have_printf_jd=yes],
    [ac_cv_cv_have_printf_jd=no])
  ])

 dnl Third try to see if the program runs correctly
 AS_IF(
  [test "x$ac_cv_cv_have_printf_jd" = xyes],
  [AC_RUN_IFELSE(
   [AC_LANG_PROGRAM(
    [[#include <sys/types.h>
#include <stdio.h>]],
    [[char string[ 3 ];
if( snprintf( string, 3, "%jd", (off_t) 10 ) < 0 ) return( 1 );
if( ( string[ 0 ] != '1' ) || ( string[ 1 ] != '0' ) ) return( 1 ); ]] )],
    [ac_cv_cv_have_printf_jd=yes],
    [ac_cv_cv_have_printf_jd=no],
    [ac_cv_cv_have_printf_jd=undetermined])
   ])

 AC_LANG_POP(C)
 CFLAGS="$SAVE_CFLAGS"

 AS_IF(
  [test "x$ac_cv_cv_have_printf_jd" = xyes],
  [AC_MSG_RESULT(
   [yes])
  AC_DEFINE(
   [HAVE_PRINTF_JD],
   [1],
   [Define to 1 whether printf supports the conversion specifier "%jd".]) ],
  [AC_MSG_RESULT(
   [$ac_cv_cv_have_printf_jd]) ])
 ])

dnl Function to detect whether printf conversion specifier "%zd" is available
AC_DEFUN([AC_CHECK_FUNC_PRINTF_ZD],
 [AC_MSG_CHECKING(
  [whether printf supports the conversion specifier "%zd"])

 SAVE_CFLAGS="$CFLAGS"
 CFLAGS="$CFLAGS -Wall -Werror"
 AC_LANG_PUSH(C)

 dnl First try to see if compilation and linkage without a parameter succeeds
 AC_LINK_IFELSE(
  [AC_LANG_PROGRAM(
   [[#include <stdio.h>]],
   [[printf( "%zd" ); ]] )],
  [ac_cv_cv_have_printf_zd=no],
  [ac_cv_cv_have_printf_zd=yes])

 dnl Second try to see if compilation and linkage with a parameter succeeds
 AS_IF(
  [test "x$ac_cv_cv_have_printf_zd" = xyes],
  [AC_LINK_IFELSE(
   [AC_LANG_PROGRAM(
    [[#include <sys/types.h>
#include <stdio.h>]],
    [[printf( "%zd", (size_t) 10 ); ]] )],
    [ac_cv_cv_have_printf_zd=yes],
    [ac_cv_cv_have_printf_zd=no])
  ])

 dnl Third try to see if the program runs correctly
 AS_IF(
  [test "x$ac_cv_cv_have_printf_zd" = xyes],
  [AC_RUN_IFELSE(
   [AC_LANG_PROGRAM(
    [[#include <sys/types.h>
#include <stdio.h>]],
    [[char string[ 3 ];
if( snprintf( string, 3, "%zd", (size_t) 10 ) < 0 ) return( 1 );
if( ( string[ 0 ] != '1' ) || ( string[ 1 ] != '0' ) ) return( 1 ); ]] )],
    [ac_cv_cv_have_printf_zd=yes],
    [ac_cv_cv_have_printf_zd=no],
    [ac_cv_cv_have_printf_zd=undetermined])
   ])

 AC_LANG_POP(C)
 CFLAGS="$SAVE_CFLAGS"

 AS_IF(
  [test "x$ac_cv_cv_have_printf_zd" = xyes],
  [AC_MSG_RESULT(
   [yes])
  AC_DEFINE(
   [HAVE_PRINTF_ZD],
   [1],
   [Define to 1 whether printf supports the conversion specifier "%zd".]) ],
  [AC_MSG_RESULT(
   [$ac_cv_cv_have_printf_zd]) ])
 ])

dnl Function to detect if wincrypt AES functions are available
AC_DEFUN([AC_CHECK_LOCAL_LIBBDE_WINCRYPT],
 [AC_SUBST(
  [LIBCRYPTO_LIBADD],
  [-ladvapi32])

 ac_cv_cypher_aes=libadvapi32
 ])
 
dnl Function to detect if openssl EVP AES functions are available
AC_DEFUN([AC_CHECK_LIBBDE_OPENSSL_EVP],
 [AC_CHECK_HEADERS([openssl/evp.h])
 
 AS_IF(
  [test "x$ac_cv_header_openssl_evp_h" = xno],
  [ac_cv_libcrypto=no],
  [AC_CHECK_OPENSSL_EVP_ZLIB_COMPATIBILE
 
  AS_IF(
   [test "x$ac_cv_openssl_evp_zlib_compatible" = xyes],
   [ac_cv_libcrypto=evp],
   [ac_cv_libcrypto=no])
 ])

 dnl Check if all required libcrypto (openssl) EVP MD functions are available
 AS_IF(
  [test "x$ac_cv_libcrypto" = xevp],
  [ac_cv_cypher_aes=libcrypto_evp
  AC_CHECK_LIB(
   crypto,
   EVP_CIPHER_CTX_init,
   [ac_cv_cypher_aes_dummy=yes],
   [ac_cv_cypher_aes=no])
  AC_CHECK_LIB(
   crypto,
   EVP_CIPHER_CTX_cleanup,
   [ac_cv_cypher_aes_dummy=yes],
   [ac_cv_cypher_aes=no])
  AC_CHECK_LIB(
   crypto,
   EVP_DecryptInit,
   [ac_cv_cypher_aes_dummy=yes],
   [ac_cv_cypher_aes=no])
  AC_CHECK_LIB(
   crypto,
   EVP_DecryptUpdate,
   [ac_cv_cypher_aes_dummy=yes],
   [ac_cv_cypher_aes=no])
  AC_CHECK_LIB(
   crypto,
   EVP_DecryptFinal,
   [ac_cv_cypher_aes_dummy=yes],
   [ac_cv_cypher_aes=no])
  AC_CHECK_LIB(
   crypto,
   EVP_EncryptInit,
   [ac_cv_cypher_aes_dummy=yes],
   [ac_cv_cypher_aes=no])
  AC_CHECK_LIB(
   crypto,
   EVP_EncryptUpdate,
   [ac_cv_cypher_aes_dummy=yes],
   [ac_cv_cypher_aes=no])
  AC_CHECK_LIB(
   crypto,
   EVP_EncryptFinal,
   [ac_cv_cypher_aes_dummy=yes],
   [ac_cv_cypher_aes=no])
  ])
 ])

dnl Function to detect if openssl AES functions are available
AC_DEFUN([AC_CHECK_LIBBDE_OPENSSL_AES],
 [AC_CHECK_HEADERS([openssl/aes.h])
 
 AS_IF(
  [test "x$ac_cv_header_openssl_aes_h" = xno],
  [ac_cv_cypher_aes=no],
  [ac_cv_cypher_aes=libcrypto
  AC_CHECK_LIB(
   crypto,
   EVP_aes_128_ecb,
   [ac_cv_cypher_aes_dummy=yes],
   [ac_cv_cypher_aes=no])
  AC_CHECK_LIB(
   crypto,
   EVP_aes_192_ecb,
   [ac_cv_cypher_aes_dummy=yes],
   [ac_cv_cypher_aes=no])
  AC_CHECK_LIB(
   crypto,
   EVP_aes_256_ecb,
   [ac_cv_cypher_aes_dummy=yes],
   [ac_cv_cypher_aes=no])
  ])
 ])
 
