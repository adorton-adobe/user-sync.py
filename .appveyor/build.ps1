if ($env:python.endswith("36-x64")) {
    $pycmd = "${env:python}\python.exe"
    & $pycmd -m venv venv
} else {
    $venvcmd = "${env:python}\Scripts\virtualenv.exe"
    & $venvcmd venv
}
.\venv\Scripts\activate.ps1
pip install -e .
pip install -e .[test]
pip install -e .[setup]
make 2>&1
dir dist
mkdir release
cp dist\user-sync.pex release\
cd release\
Get-Command python
$pyver=$(python -V 2>&1) -replace "Python ","py" -replace "\.",""
echo "pyver: ${pyver}"
7z a "user-sync-${env:APPVEYOR_REPO_TAG_NAME}-win64-${pyver}.tar.gz" user-sync.pex
7z a "user-sync-${env:APPVEYOR_REPO_TAG_NAME}-win64-${pyver}.zip" user-sync.pex
cd ..
7z a -ttar -so -r examples.tar examples | 7z a -si release\examples.tar.gz
7z a -r release\examples.zip examples\
dir releases
