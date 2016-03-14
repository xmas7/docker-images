# build gcc 5.2.0 (http://en.librehat.com/blog/build-gcc-5-dot-2-on-rhel-6/)
urls="http://ftpmirror.gnu.org/gcc/gcc-5.2.0/gcc-5.2.0.tar.bz2 \
         http://gnu.askapache.com/gmp/gmp-6.1.0.tar.bz2 \
         ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz \
         http://www.mpfr.org/mpfr-current/mpfr-3.1.3.tar.bz2"
for url in $urls; do
   curl $url -LO ;
done
wait
mkdir /gcc-build && tar xjf gcc-5.2.0.tar.bz2 -C /gcc-build --strip-components=1
mkdir /gcc-build/gmp && tar xjf gmp-6.1.0.tar.bz2 -C /gcc-build/gmp --strip-components=1
mkdir /gcc-build/mpc && tar xf mpc-1.0.3.tar.gz -C /gcc-build/mpc --strip-components=1
mkdir /gcc-build/mpfr && tar xjf mpfr-3.1.3.tar.bz2 -C /gcc-build/mpfr --strip-components=1
rm -rf *tar\.*
mkdir /gcc-build/work
cd /gcc-build/work
curl -LO http://ftp.gnu.org/gnu/binutils/binutils-2.26.tar.bz2
tar xf binutils-2.26.tar.bz2
cd /gcc-build/work/binutils-2.26
scl enable devtoolset-2 './configure --prefix=/usr/local
                                     --enable-plugin
                                     --with-sysroot=/
                                     --enable-targets=x86_64-redhat-linux-gnu,i386-redhat-linux-gnu
                         && make -j$(getconf _NPROCESSORS_ONLN) && make install'
cd /gcc-build/work
scl enable devtoolset-2 '/gcc-build/configure
      --prefix=/usr/local/gcc_tmp
      --enable-multilib
      --target=x86_64-redhat-linux-gnu
      --enable-languages=c,c++,fortran
      --enable-libstdcxx-threads
      --enable-libstdcxx-time
      --enable-shared
      --enable-__cxa_atexit
      --disable-libunwind-exceptions
      --disable-libada
      --host x86_64-redhat-linux-gnu
      --build x86_64-redhat-linux-gnu
      --enable-plugin
      --disable-libunwind-exceptions --enable-clocale=gnu
      --disable-libstdcxx-pch'
scl enable devtoolset-2 'make -j$(getconf _NPROCESSORS_ONLN) all'
scl enable devtoolset-2 'make install'
cd /
export PATH=/usr/local/gcc_tmp/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/gcc_tmp/lib64:$LD_LIBRARY_PATH
rm -rf /gcc-build/work
mkdir /gcc-build/work
cd /gcc-build/work
/gcc-build/configure                   \
      --prefix=/usr/local/gcc5_abi5    \
      --enable-multilib                \
      --target=x86_64-redhat-linux-gnu \
      --enable-languages=c,c++,fortran \
      --enable-libstdcxx-threads       \
      --enable-libstdcxx-time          \
      --enable-shared                  \
      --enable-__cxa_atexit            \
      --disable-libunwind-exceptions   \
      --disable-libada                 \
      --host x86_64-redhat-linux-gnu   \
      --build x86_64-redhat-linux-gnu  \
      --enable-plugin                  \
      --disable-libunwind-exceptions   \
      --enable-clocale=gnu             \
      --disable-libstdcxx-pch          \
      --with-default-libstdcxx-abi=new
make -j$(getconf _NPROCESSORS_ONLN)
make install-strip
cd /usr/local/gcc5_abi5/bin
ln -sf gcc cc
rm -rf /gcc-build/work
mkdir /gcc-build/work
cd /gcc-build/work
/gcc-build/configure                     \
        --prefix=/usr/local/gcc5_abi4    \
        --enable-multilib                \
        --target=x86_64-redhat-linux-gnu \
        --enable-languages=c,c++,fortran \
        --enable-libstdcxx-threads       \
        --enable-libstdcxx-time          \
        --enable-shared                  \
        --enable-__cxa_atexit            \
        --disable-libunwind-exceptions   \
        --disable-libada                 \
        --host x86_64-redhat-linux-gnu   \
        --build x86_64-redhat-linux-gnu  \
        --enable-plugin                  \
        --disable-libunwind-exceptions   \
        --enable-clocale=gnu             \
        --disable-libstdcxx-pch          \
        --with-default-libstdcxx-abi=gcc4-compatible
make -j$(getconf _NPROCESSORS_ONLN)
make install-strip
cd /usr/local/gcc5_abi4/bin
ln -sf gcc cc
rm -rf /gcc-build
rm -rf /usr/local/gcc_tmp
