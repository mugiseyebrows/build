@echo off
rem This file is generated from build-qt.pbat, all edits will be lost
set PATH=C:\windows\system32;C:\windows;C:\Program Files\7-Zip;%~dp0mingw64\bin;C:\Strawberry\perl\bin;%~dp0Qt-5.15.2-mingw64\bin;%~dp0postgresql-14\bin;C:\mysql\lib;C:\Miniconda\python;C:\Miniconda\Scripts;C:\Users\Stanislav\Miniconda3\Scripts;C:\Users\Stanislav\Miniconda3\python;%PATH%
set NOMAKE=-nomake tests -nomake examples
pip install mugideploy mugicli

pushd %~dp0
if not exist x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z curl -L -o x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z https://storage.googleapis.com/qt-binaries/x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z
if not exist qtbase-everywhere-src-5.15.2.zip curl -L -o qtbase-everywhere-src-5.15.2.zip https://download.qt.io/official_releases/qt/5.15/5.15.2/submodules/qtbase-everywhere-src-5.15.2.zip
if not exist qtsvg-everywhere-src-5.15.2.zip curl -L -o qtsvg-everywhere-src-5.15.2.zip https://download.qt.io/official_releases/qt/5.15/5.15.2/submodules/qtsvg-everywhere-src-5.15.2.zip
xcopy /s /q /y /i "C:\Program Files\PostgreSQL\14\bin" postgresql-14\bin
xcopy /s /q /y /i "C:\Program Files\PostgreSQL\14\include" postgresql-14\include
popd

pushd %~dp0
if not exist mingw64 7z x -y x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z
if not exist qtbase-everywhere-src-5.15.2 7z x -y qtbase-everywhere-src-5.15.2.zip
if not exist qtsvg-everywhere-src-5.15.2 7z x -y qtsvg-everywhere-src-5.15.2.zip
popd

pushd %~dp0
rmdir /q /s Qt-5.15.2-mingw64
pushd qtbase-everywhere-src-5.15.2
del /f config.cache
call configure -prefix %~dp0Qt-5.15.2-mingw64 -opensource -confirm-license -shared -platform win32-g++ -opengl desktop -release %NOMAKE%
mingw32-make -j2
mingw32-make install
popd
pyfind Qt-5.15.2-mingw64 -type f > base.txt
pushd qtbase-everywhere-src-5.15.2
del /f config.cache
call configure -prefix %~dp0Qt-5.15.2-mingw64 -opensource -confirm-license -shared -plugin-sql-mysql -platform win32-g++ -opengl desktop -release %NOMAKE% MYSQL_PREFIX=C:\mysql MYSQL_INCDIR=C:\mysql\include MYSQL_LIBDIR=C:\mysql\lib
mingw32-make -j2
mingw32-make install
popd
pyfind Qt-5.15.2-mingw64 -type f > mysql-plugin.txt
pushd qtbase-everywhere-src-5.15.2
del /f config.cache
call configure -prefix %~dp0Qt-5.15.2-mingw64 -opensource -confirm-license -shared -plugin-sql-mysql -plugin-sql-psql -platform win32-g++ -opengl desktop -release %NOMAKE% MYSQL_PREFIX=C:\mysql MYSQL_INCDIR=C:\mysql\include MYSQL_LIBDIR=C:\mysql\lib PSQL_INCDIR=%~dp0postgresql-14\include PSQL_LIBDIR=%~dp0postgresql-14\bin
mingw32-make -j2
mingw32-make install
popd
pyfind Qt-5.15.2-mingw64 -type f > psql-plugin.txt
pushd qtsvg-everywhere-src-5.15.2
qmake
mingw32-make -j2
mingw32-make install
popd
pyfind Qt-5.15.2-mingw64 -type f > svg.txt
pycat base.txt mysql-plugin.txt | pysort | pyuniq -u > mysql-plugin-diff.txt
pycat mysql-plugin.txt psql-plugin.txt | pysort | pyuniq -u > psql-plugin-diff.txt
pycat psql-plugin.txt svg.txt | pysort | pyuniq -u > svg-diff.txt
del /f Qt-5.15.2-mingw64-base.zip
del /f Qt-5.15.2-mingw64-qsqlmysql.zip
del /f Qt-5.15.2-mingw64-qsqlpsql.zip
del /f Qt-5.15.2-mingw64-svg.zip
del /f qsqlmysql-mingw64.zip
del /f qsqlpsql-mingw64.zip
pyzip a --list base.txt Qt-5.15.2-mingw64-base.zip
pyzip a --list mysql-plugin-diff.txt Qt-5.15.2-mingw64-qsqlmysql.zip
pyzip a --list psql-plugin-diff.txt Qt-5.15.2-mingw64-qsqlpsql.zip
pyzip a --list svg-diff.txt Qt-5.15.2-mingw64-svg.zip
mugideploy list --bin Qt-5.15.2-mingw64\plugins\sqldrivers\qsqlmysql.dll | pygrep mysql^|postgres | pygrep -v qsql | pyxargs pyzip a --dir Qt-5.15.2-mingw64\bin Qt-5.15.2-mingw64-qsqlmysql.zip
mugideploy list --bin Qt-5.15.2-mingw64\plugins\sqldrivers\qsqlpsql.dll | pygrep mysql^|postgres | pygrep -v qsql | pyxargs pyzip a --dir Qt-5.15.2-mingw64\bin Qt-5.15.2-mingw64-qsqlpsql.zip
popd


