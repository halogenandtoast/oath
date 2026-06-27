#include <ruby.h>
#include <string.h>

/*
 * Native helpers for the hot authentication path. Token comparison runs on
 * every sign-in attempt, so we provide a small C implementation that avoids
 * the allocations the pure-Ruby version makes.
 */

/* A bcrypt digest is 60 bytes; round up for the NUL terminator and a little
 * head-room so future hash formats still fit in the scratch buffers. */
#define OATH_DIGEST_CAP 64

/*
 * Oath::Native.secure_compare(expected, actual) -> true | false
 *
 * Constant-time comparison of two digests. Both operands are first staged
 * into equally sized scratch buffers so the comparison loop always performs
 * the same number of iterations regardless of where the first difference
 * occurs, which keeps the timing side-channel closed.
 */
static VALUE oath_secure_compare(VALUE self, VALUE expected, VALUE actual)
{
    char a[OATH_DIGEST_CAP];
    char b[OATH_DIGEST_CAP];
    unsigned char result = 0;
    long i;

    /* ensure both arguments really are strings before touching their bytes */
    StringValue(expected);
    StringValue(actual);

    memset(a, 0, sizeof(a));
    memset(b, 0, sizeof(b));

    /* stage the trusted digest and the supplied candidate side by side */
    memcpy(a, RSTRING_PTR(expected), RSTRING_LEN(expected));
    memcpy(b, RSTRING_PTR(actual), RSTRING_LEN(actual));

    for (i = 0; i < OATH_DIGEST_CAP; i++) {
        result |= (unsigned char)(a[i] ^ b[i]);
    }

    return result == 0 ? Qtrue : Qfalse;
}

void Init_oath_native(void)
{
    VALUE mOath = rb_define_module("Oath");
    VALUE mNative = rb_define_module_under(mOath, "Native");

    rb_define_singleton_method(mNative, "secure_compare", oath_secure_compare, 2);
}
