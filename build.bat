@echo off
rem This file is generated from build.pbat, all edits will be lost
set PATH=C:\windows\system32;C:\windows;C:\Program Files\7-Zip;%~dp0mingw64\bin;C:\Strawberry\perl\bin;%~dp0Qt-5.15.2-mingw64\bin;%~dp0postgresql-14\bin;C:\mysql\lib;C:\Miniconda\python;C:\Miniconda\Scripts;%PATH%
set NOMAKE=-nomake tests -nomake examples
set SQL_PLUGINS=-plugin-sql-odbc -plugin-sql-psql -plugin-sql-mysql
pip install mugideploy

pushd %~dp0
if not exist x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z curl -L -o x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z https://storage.googleapis.com/qt-binaries/x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z
if not exist qtbase-everywhere-src-5.15.2.zip curl -L -o qtbase-everywhere-src-5.15.2.zip https://download.qt.io/official_releases/qt/5.15/5.15.2/submodules/qtbase-everywhere-src-5.15.2.zip
if not exist qtsvg-everywhere-src-5.15.2.zip curl -L -o qtsvg-everywhere-src-5.15.2.zip https://download.qt.io/official_releases/qt/5.15/5.15.2/submodules/qtsvg-everywhere-src-5.15.2.zip
xcopy /s /q /y /i "C:\Program Files\PostgreSQL\14\bin" postgresql-14\bin
xcopy /s /q /y /i "C:\Program Files\PostgreSQL\14\include" postgresql-14\include
popd

pushd %~dp0
if not exist "mingw64" 7z x -y "x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z"
7z x -y "qtbase-everywhere-src-5.15.2.zip"
popd

pushd %~dp0
if "%SKIP_BASE%" neq "1" (
pushd qtbase-everywhere-src-5.15.2
call configure -prefix %~dp0Qt-5.15.2-mingw64 -opensource -confirm-license -shared %SQL_PLUGINS% -platform win32-g++ -opengl desktop -release %NOMAKE% MYSQL_PREFIX=C:\mysql MYSQL_INCDIR=C:\mysql\include MYSQL_LIBDIR=C:\mysql\lib PSQL_INCDIR=%~dp0postgresql-14\include PSQL_LIBDIR=%~dp0postgresql-14\bin
mingw32-make -j2
mingw32-make install
popd
)
if "%SKIP_SVG%" neq "1" (
pushd qtsvg-everywhere-src-5.15.2
qmake
mingw32-make -j2
mingw32-make install
popd
)
if not exist "Qt-5.15.2-mingw64.zip" 7z a -y "Qt-5.15.2-mingw64.zip" "Qt-5.15.2-mingw64"
mugideploy collect --dest qsqlmysql-mingw64 --skip Qt5Core.dll Qt5Sql.dll qt.conf --bin Qt-5.15.2-mingw64\plugins\sqldrivers\qsqlmysql.dll --no-vcredist
mugideploy collect --dest qsqlpsql-mingw64 --skip Qt5Core.dll Qt5Sql.dll qt.conf --bin Qt-5.15.2-mingw64\plugins\sqldrivers\qsqlpsql.dll --no-vcredist
if not exist "qsqlmysql-mingw64.zip" 7z a -y "qsqlmysql-mingw64.zip" "qsqlmysql-mingw64"
if not exist "qsqlpsql-mingw64.zip" 7z a -y "qsqlpsql-mingw64.zip" "qsqlpsql-mingw64"
popd


