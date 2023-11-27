#ifndef POSTCOPY_FT
#define POSTCOPY_FT

/*
 * Log level printing for post copy FT debugging
 * There are log levels 0-3
 * 0: print critical errors statements
 * 1: log essential behavior
 * 2: general purpose debug statements
 * 3: extra verbose debug statements
 *
 * DEBUG_FT_LVL is defined default at -1, which disables debug printing
 *
 * Generally, setting this at 2 is a good idea for general use
 */
#define DEBUG_FT_LVL -1
#define debug_print_FT(ft_debug_lvl, fmt, ...) \
              do { if ( DEBUG_FT_LVL >= ft_debug_lvl) fprintf(stderr, fmt, __VA_ARGS__); } while (0)



// To disable postcopy fault tolerant code, comment out the line below
#define USE_POSTCOPY_FT
#endif
