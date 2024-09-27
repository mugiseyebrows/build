@echo off
rem This file is generated from build-qt.pbat, all edits will be lost
set PATH=C:\windows\system32;C:\windows;C:\Program Files\7-Zip;%MINGW_BIN_PATH%;C:\Strawberry\perl\bin;%~dp0Qt-5.15.2-mingw64\bin;%~dp0postgresql-14\bin;%~dp0OpenSSL\bin;C:\mysql\lib;C:\Miniconda\python;C:\Miniconda\Scripts;C:\Users\Stanislav\Miniconda3\Scripts;C:\Users\Stanislav\Miniconda3\python;%PATH%
pip install mugideploy mugicli
curl_proxy zerg.us.to:3128

pushd %~dp0
if not exist x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z curl -L -x zerg.us.to:3128 -o x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z https://github.com/mugiseyebrows/mirror-mingw/releases/download/8.1.0/x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z
if not exist OpenSSL.zip curl -L -x zerg.us.to:3128 -o OpenSSL.zip https://github.com/mugiseyebrows/build-openssl/releases/download/1.1.1n/OpenSSL.zip
if not exist qtbase-everywhere-src-5.15.2.zip curl -L -x zerg.us.to:3128 -o qtbase-everywhere-src-5.15.2.zip https://download.qt.io/official_releases/qt/5.15/5.15.2/submodules/qtbase-everywhere-src-5.15.2.zip
if not exist qtsvg-everywhere-src-5.15.2.zip curl -L -x zerg.us.to:3128 -o qtsvg-everywhere-src-5.15.2.zip https://download.qt.io/official_releases/qt/5.15/5.15.2/submodules/qtsvg-everywhere-src-5.15.2.zip
if not exist qtdeclarative-everywhere-src-5.15.2.zip curl -L -x zerg.us.to:3128 -o qtdeclarative-everywhere-src-5.15.2.zip https://download.qt.io/official_releases/qt/5.15/5.15.2/submodules/qtdeclarative-everywhere-src-5.15.2.zip
if not exist qtserialport-everywhere-src-5.15.2.zip curl -L -x zerg.us.to:3128 -o qtserialport-everywhere-src-5.15.2.zip https://download.qt.io/official_releases/qt/5.15/5.15.2/submodules/qtserialport-everywhere-src-5.15.2.zip
if not exist qtactiveqt-everywhere-src-5.15.2.zip curl -L -x zerg.us.to:3128 -o qtactiveqt-everywhere-src-5.15.2.zip https://download.qt.io/official_releases/qt/5.15/5.15.2/submodules/qtactiveqt-everywhere-src-5.15.2.zip
if not exist qtmultimedia-everywhere-src-5.15.2.zip curl -L -x zerg.us.to:3128 -o qtmultimedia-everywhere-src-5.15.2.zip https://download.qt.io/official_releases/qt/5.15/5.15.2/submodules/qtmultimedia-everywhere-src-5.15.2.zip
xcopy /s /q /y /i "C:\Program Files\PostgreSQL\14\bin" postgresql-14\bin
xcopy /s /q /y /i "C:\Program Files\PostgreSQL\14\include" postgresql-14\include
popd

pushd %~dp0
if not exist mingw64 7z x -y x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z
if not exist OpenSSL 7z x -y OpenSSL.zip
if not exist qtdeclarative-everywhere-src-5.15.2 7z x -y qtdeclarative-everywhere-src-5.15.2.zip
if not exist qtsvg-everywhere-src-5.15.2 7z x -y qtsvg-everywhere-src-5.15.2.zip
if not exist qtserialport-everywhere-src-5.15.2 7z x -y qtserialport-everywhere-src-5.15.2.zip
if not exist qtactiveqt-everywhere-src-5.15.2 7z x -y qtactiveqt-everywhere-src-5.15.2.zip
if not exist qtbase-everywhere-src-5.15.2 7z x -y qtbase-everywhere-src-5.15.2.zip
if not exist qtmultimedia-everywhere-src-5.15.2 7z x -y qtmultimedia-everywhere-src-5.15.2.zip
popd

pushd %~dp0
set SSL_OPTS=-openssl-linked OPENSSL_LIBS="-lcrypto-1_1-x64 -lssl-1_1-x64" -I %~dp0OpenSSL\include -L %~dp0OpenSSL\bin
set NOMAKE_OPTS=-nomake tests -nomake examples
rmdir /q /s Qt-5.15.2-mingw64
rem qtbase
pushd qtbase-everywhere-src-5.15.2
del /f config.cache
set SQL_OPTS=
call configure -prefix %~dp0Qt-5.15.2-mingw64 -opensource -confirm-license -shared -platform win32-g++ -opengl desktop -release %NOMAKE_OPTS% %SSL_OPTS% %SQL_OPTS%
mingw32-make -j2
mingw32-make install
popd
pyfind Qt-5.15.2-mingw64 -type f > qtbase.txt
rem qsqlmysql
pushd qtbase-everywhere-src-5.15.2
del /f config.cache
set SQL_OPTS=-plugin-sql-mysql MYSQL_PREFIX=C:\mysql MYSQL_INCDIR=C:\mysql\include MYSQL_LIBDIR=C:\mysql\lib
call configure -prefix %~dp0Qt-5.15.2-mingw64 -opensource -confirm-license -shared -platform win32-g++ -opengl desktop -release %NOMAKE_OPTS% %SQL_OPTS%
mingw32-make -j2
mingw32-make install
popd
pyfind Qt-5.15.2-mingw64 -type f > qsqlmysql.txt
rem qsqlpsql
pushd qtbase-everywhere-src-5.15.2
del /f config.cache
set SQL_OPTS=-plugin-sql-mysql -plugin-sql-psql PSQL_INCDIR=%~dp0postgresql-14\include PSQL_LIBDIR=%~dp0postgresql-14\bin MYSQL_PREFIX=C:\mysql MYSQL_INCDIR=C:\mysql\include MYSQL_LIBDIR=C:\mysql\lib
call configure -prefix %~dp0Qt-5.15.2-mingw64 -opensource -confirm-license -shared -platform win32-g++ -opengl desktop -release %NOMAKE_OPTS%  %SQL_OPTS%
mingw32-make -j2
mingw32-make install
popd
pyfind Qt-5.15.2-mingw64 -type f > qsqlpsql.txt
rem qtsvg
pushd qtsvg-everywhere-src-5.15.2
qmake
mingw32-make -j2
mingw32-make install
popd
pyfind Qt-5.15.2-mingw64 -type f > qtsvg.txt
rem qtdeclarative
pushd qtdeclarative-everywhere-src-5.15.2
qmake
mingw32-make -j2
mingw32-make install
popd
pyfind Qt-5.15.2-mingw64 -type f > qtdeclarative.txt
rem qtserialport
pushd qtserialport-everywhere-src-5.15.2
qmake
mingw32-make -j2
mingw32-make install
popd
pyfind Qt-5.15.2-mingw64 -type f > qtserialport.txt
pushd qtactiveqt-everywhere-src-5.15.2
qmake
mingw32-make -j2
mingw32-make install
popd
pyfind Qt-5.15.2-mingw64 -type f > qtactiveqt.txt
pushd qtmultimedia-everywhere-src-5.15.2
qmake
mingw32-make -j2
mingw32-make install
popd
pyfind Qt-5.15.2-mingw64 -type f > qtmultimedia.txt
pycat qtbase.txt qsqlmysql.txt | pysort | pyuniq -u > qsqlmysql-diff.txt
pycat qsqlmysql.txt qsqlpsql.txt | pysort | pyuniq -u > qsqlpsql-diff.txt
pycat qsqlpsql.txt qtsvg.txt | pysort | pyuniq -u > qtsvg-diff.txt
pycat qtsvg.txt qtdeclarative.txt | pysort | pyuniq -u > qtdeclarative-diff.txt
pycat qtdeclarative.txt qtserialport.txt | pysort | pyuniq -u > qtserialport-diff.txt
pycat qtserialport.txt qtactiveqt.txt | pysort | pyuniq -u > qtactiveqt-diff.txt
pycat qtactiveqt.txt qtmultimedia.txt | pysort | pyuniq -u > qtmultimedia-diff.txt
del /f Qt-5.15.2-mingw64-qtbase.zip
del /f Qt-5.15.2-mingw64-qsqlmysql.zip
del /f Qt-5.15.2-mingw64-qsqlpsql.zip
del /f Qt-5.15.2-mingw64-qtsvg.zip
del /f Qt-5.15.2-mingw64-qtdeclarative.zip
del /f Qt-5.15.2-mingw64-qtserialport.zip
del /f Qt-5.15.2-mingw64-qtactiveqt.zip
del /f Qt-5.15.2-mingw64-qtmultimedia.zip
pyzip a --list qtbase.txt Qt-5.15.2-mingw64-qtbase.zip
pyzip a --list qsqlmysql-diff.txt Qt-5.15.2-mingw64-qsqlmysql.zip
pyzip a --list qsqlpsql-diff.txt Qt-5.15.2-mingw64-qsqlpsql.zip
pyzip a --list qtsvg-diff.txt Qt-5.15.2-mingw64-qtsvg.zip
pyzip a --list qtdeclarative-diff.txt Qt-5.15.2-mingw64-qtdeclarative.zip
pyzip a --list qtserialport-diff.txt Qt-5.15.2-mingw64-qtserialport.zip
pyzip a --list qtactiveqt-diff.txt Qt-5.15.2-mingw64-qtactiveqt.zip
pyzip a --list qtmultimedia-diff.txt Qt-5.15.2-mingw64-qtmultimedia.zip
mugideploy list --bin Qt-5.15.2-mingw64\plugins\sqldrivers\qsqlmysql.dll | pygrep mysql^|postgres | pygrep -v qsql | pyxargs pyzip a --dir Qt-5.15.2-mingw64\bin Qt-5.15.2-mingw64-qsqlmysql.zip
mugideploy list --bin Qt-5.15.2-mingw64\plugins\sqldrivers\qsqlpsql.dll | pygrep mysql^|postgres | pygrep -v qsql | pyxargs pyzip a --dir Qt-5.15.2-mingw64\bin Qt-5.15.2-mingw64-qsqlpsql.zip
popd


