include ../Makefile.template

CC				= emcc
CFLAGS			= -v -c -x objective-c -pipe -Wmost -Wno-trigraphs -Wreturn-type -fconstant-cfstrings -fno-exceptions -fblocks -fobjc-runtime=macosx -DDEPLOYMENT_TARGET_EMSCRIPTEN=1 -DMAC_OS_X_VERSION_MAX_ALLOWED=MAC_OS_X_VERSION_10_9 -I./ -I./Source -I./CommonCrypto -I./Source/Digest -I./Source/CommonCryptoSPI -I./Source/ccOpenssl -I./Source/CAST -I./Source/libtomcrypt/src/ciphers/RC4 -I./Source/libtomcrypt/src/headers -I./Source/libtomcrypt/src/padding/ansix923 -I./Source/libtomcrypt/src/padding/iso10126 -I./Source/libtomcrypt/src/padding/nopadding -I./Source/libtomcrypt/src/padding/pkcs7 -I./Source/ccUtilities -I./Source/API -I./Source/GladmanAES -I./Source/AESedp -I./Source/libtomcrypt/src/ciphers/aesedpport -I./Source/libtomcrypt/src/hashes -I./Source/libtomcrypt/src/hashes/skein/Optimized_64bit

BUILD_DIR		= build/debug
INSTALL_DIR		= $(EMSCRIPTEN)/system/frameworks

PUBLIC_HEADERS	= $(wildcard CommonCrypto/*.h)
PRIVATE_HEADERS	= $(wildcard private_include/**/*.h)
RESOURCE_DIR	= resource

SOURCES= \
    Source/API/CommonCMAC.c \
    Source/Digest/md2_dgst.c \
    Source/Digest/md4_dgst.c \
    Source/Digest/sha1.c \
    Source/Digest/sha2.c \
    Source/ccOpenssl/set_key.c \
    Source/ccOpenssl/opensslDES.c \
    Source/ccOpenssl/des_enc.c \
    Source/CAST/c_ecb.c \
    Source/CAST/c_enc.c \
    Source/CAST/c_skey.c \
    Source/CAST/ccCast.c \
    Source/RC2/ccRC2.c \
    Source/RC2/rc2.c \
    Source/libtomcrypt/src/ciphers/cast5.c \
    Source/libtomcrypt/src/ciphers/des.c \
    Source/libtomcrypt/src/ciphers/rc2.c \
    Source/libtomcrypt/src/ciphers/RC4/rc4_enc.c \
    Source/libtomcrypt/src/ciphers/RC4/rc4_skey.c \
    Source/libtomcrypt/src/ciphers/rc5.c \
    Source/libtomcrypt/src/hashes/helper/hash_file.c \
    Source/libtomcrypt/src/hashes/helper/hash_filehandle.c \
    Source/libtomcrypt/src/hashes/helper/hash_memory.c \
    Source/libtomcrypt/src/hashes/helper/hash_memory_multi.c \
    Source/libtomcrypt/src/hashes/md2.c \
    Source/libtomcrypt/src/hashes/md4.c \
    Source/libtomcrypt/src/hashes/md5.c \
    Source/libtomcrypt/src/hashes/rmd128.c \
    Source/libtomcrypt/src/hashes/rmd160.c \
    Source/libtomcrypt/src/hashes/rmd256.c \
    Source/libtomcrypt/src/hashes/rmd320.c \
    Source/libtomcrypt/src/hashes/sha1.c \
    Source/libtomcrypt/src/hashes/sha2/sha256.c \
    Source/libtomcrypt/src/hashes/sha2/sha512.c \
    Source/libtomcrypt/src/misc/crypt/crypt.c \
    Source/libtomcrypt/src/misc/crypt/crypt_argchk.c \
    Source/libtomcrypt/src/misc/crypt/crypt_cipher_descriptor.c \
    Source/libtomcrypt/src/misc/crypt/crypt_cipher_is_valid.c \
    Source/libtomcrypt/src/misc/crypt/crypt_find_cipher.c \
    Source/libtomcrypt/src/misc/crypt/crypt_find_cipher_any.c \
    Source/libtomcrypt/src/misc/crypt/crypt_find_cipher_id.c \
    Source/libtomcrypt/src/misc/crypt/crypt_find_hash.c \
    Source/libtomcrypt/src/misc/crypt/crypt_find_hash_any.c \
    Source/libtomcrypt/src/misc/crypt/crypt_find_hash_id.c \
    Source/libtomcrypt/src/misc/crypt/crypt_find_hash_oid.c \
    Source/libtomcrypt/src/misc/crypt/crypt_find_prng.c \
    Source/libtomcrypt/src/misc/crypt/crypt_hash_descriptor.c \
    Source/libtomcrypt/src/misc/crypt/crypt_hash_is_valid.c \
    Source/libtomcrypt/src/misc/crypt/crypt_ltc_mp_descriptor.c \
    Source/libtomcrypt/src/misc/crypt/crypt_mode_descriptor.c \
    Source/libtomcrypt/src/misc/crypt/crypt_register_cipher.c \
    Source/libtomcrypt/src/misc/crypt/crypt_register_hash.c \
    Source/libtomcrypt/src/misc/crypt/crypt_unregister_cipher.c \
    Source/libtomcrypt/src/misc/crypt/crypt_unregister_hash.c \
    Source/libtomcrypt/src/misc/error_to_string.c \
    Source/libtomcrypt/src/misc/zeromem.c \
    Source/libtomcrypt/src/modes/cbc/cbc_decrypt.c \
    Source/libtomcrypt/src/modes/cbc/cbc_descriptor.c \
    Source/libtomcrypt/src/modes/cbc/cbc_done.c \
    Source/libtomcrypt/src/modes/cbc/cbc_encrypt.c \
    Source/libtomcrypt/src/modes/cbc/cbc_getiv.c \
    Source/libtomcrypt/src/modes/cbc/cbc_setiv.c \
    Source/libtomcrypt/src/modes/cbc/cbc_start.c \
    Source/libtomcrypt/src/modes/cfb/cfb_decrypt.c \
    Source/libtomcrypt/src/modes/cfb/cfb_descriptor.c \
    Source/libtomcrypt/src/modes/cfb/cfb_done.c \
    Source/libtomcrypt/src/modes/cfb/cfb_encrypt.c \
    Source/libtomcrypt/src/modes/cfb/cfb_getiv.c \
    Source/libtomcrypt/src/modes/cfb/cfb_setiv.c \
    Source/libtomcrypt/src/modes/cfb/cfb_start.c \
    Source/libtomcrypt/src/modes/ctr/ctr_decrypt.c \
    Source/libtomcrypt/src/modes/ctr/ctr_descriptor.c \
    Source/libtomcrypt/src/modes/ctr/ctr_done.c \
    Source/libtomcrypt/src/modes/ctr/ctr_encrypt.c \
    Source/libtomcrypt/src/modes/ctr/ctr_getiv.c \
    Source/libtomcrypt/src/modes/ctr/ctr_setiv.c \
    Source/libtomcrypt/src/modes/ctr/ctr_start.c \
    Source/libtomcrypt/src/modes/ctr/ctr_test.c \
    Source/libtomcrypt/src/modes/ecb/ecb_decrypt.c \
    Source/libtomcrypt/src/modes/ecb/ecb_descriptor.c \
    Source/libtomcrypt/src/modes/ecb/ecb_done.c \
    Source/libtomcrypt/src/modes/ecb/ecb_encrypt.c \
    Source/libtomcrypt/src/modes/ecb/ecb_start.c \
    Source/libtomcrypt/src/modes/ofb/ofb_decrypt.c \
    Source/libtomcrypt/src/modes/ofb/ofb_descriptor.c \
    Source/libtomcrypt/src/modes/ofb/ofb_done.c \
    Source/libtomcrypt/src/modes/ofb/ofb_encrypt.c \
    Source/libtomcrypt/src/modes/ofb/ofb_getiv.c \
    Source/libtomcrypt/src/modes/ofb/ofb_setiv.c \
    Source/libtomcrypt/src/modes/ofb/ofb_start.c \
    Source/libtomcrypt/src/modes/rc4_stream.c \
    Source/libtomcrypt/src/modes/unimplemented.c \
    Source/libtomcrypt/src/modes/xts/xts_decrypt.c \
    Source/libtomcrypt/src/modes/xts/xts_descriptor.c \
    Source/libtomcrypt/src/modes/xts/xts_done.c \
    Source/libtomcrypt/src/modes/xts/xts_encrypt.c \
    Source/libtomcrypt/src/modes/xts/xts_init.c \
    Source/libtomcrypt/src/modes/xts/xts_mult_x.c \
    Source/libtomcrypt/src/modes/xts/xts_test.c \
    Source/libtomcrypt/src/padding/ansix923/ansi923pad.c \
    Source/libtomcrypt/src/padding/iso10126/iso10126pad.c \
    Source/libtomcrypt/src/padding/nopadding/nopad.c \
    Source/libtomcrypt/src/padding/pkcs7/pkcs7pad.c \
    Source/ccUtilities/ccdebug.c \
    Source/API/CommonCryptor.c \
    Source/API/CommonHMAC.c \
    Source/API/CommonKeyDerivation.c \
    Source/API/CommonSymmetricKeywrap.c \
    Source/API/CommonDigest.c \
    Source/GladmanAES/aescrypt.c \
    Source/GladmanAES/aeskey.c \
    Source/GladmanAES/aestab.c \
    Source/GladmanAES/ccNewGladman.c \
    Source/AESedp/AES.c \
    Source/libtomcrypt/src/ciphers/aesedpport/aesedp.c \
    Source/libtomcrypt/src/hashes/skein_ltc.c \
    Source/libtomcrypt/src/hashes/skein/Optimized_64bit/skein.c \
    Source/libtomcrypt/src/hashes/skein/Optimized_64bit/skein_dropin.c \
    Source/libtomcrypt/src/hashes/skein/Optimized_64bit/skein_debug.c \
    Source/libtomcrypt/src/hashes/skein/Optimized_64bit/skein_block.c \
    Source/libtomcrypt/src/hashes/skein/Optimized_64bit/SHA3api_ref.c \
    Source/API/CommonRandom.c \
    Source/libtomcrypt/src/ciphers/aesedpport/aesxts.c \
    Source/libtomcrypt/src/modes/cfb8/cfb8_decrypt.c \
    Source/libtomcrypt/src/modes/cfb8/cfb8_descriptor.c \
    Source/libtomcrypt/src/modes/cfb8/cfb8_done.c \
    Source/libtomcrypt/src/modes/cfb8/cfb8_encrypt.c \
    Source/libtomcrypt/src/modes/cfb8/cfb8_getiv.c \
    Source/libtomcrypt/src/modes/cfb8/cfb8_setiv.c \
    Source/libtomcrypt/src/modes/cfb8/cfb8_start.c

$(eval $(call framework_build, CommonCrypto, $(BUILD_DIR), $(INSTALL_DIR), $(SOURCES), $(PUBLIC_HEADERS), $(PRIVATE_HEADERS), $(RESOURCE_DIR)))

EXCLUDED = \
    Source/Digest/sha1edpBigEndian.s \
    Source/Digest/sha1edpLittleEndian.s \
    Source/AESedp/Intel/AES.s \
    Source/AESedp/Intel/DecryptCBC.s \
    Source/AESedp/Intel/EncryptCBC.s \
    Source/libtomcrypt/src/ciphers/aesedpport/AES.s \
    Source/libtomcrypt/src/ciphers/aesedpport/aes_crypt_hw.s \
    Source/libtomcrypt/src/ciphers/aesedpport/aes_key_hw.s \
    Source/libtomcrypt/src/ciphers/aesedpport/aes_modes_asm.s \
    Source/libtomcrypt/src/ciphers/aesedpport/aes_modes_hw.s \
    Source/libtomcrypt/src/ciphers/aesedpport/aesxts_asm.s \
    Source/Digest/sha256_nossse3.s \
    Source/Digest/sha256.s \
    Source/Digest/md5_dgst.c \
