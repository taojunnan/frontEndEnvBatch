@echo off
echo.
echo  ------------------ ǰ�˻���һ������ ------------------
echo.

echo **��ȷ��ʹ�ù���ԱȨ�����У����������ʼ**
echo.
pause>nul

rem �������ԱȨ������ʱ·������
cd "%~dp0"

rem ��Ҫ��װ��nodejs�汾�����а汾����������鿴��https://registry.npmmirror.com/binary.html?path=node/
set nodejsVersion=14.19.0
rem ��Ҫ��װ��nodejs ��64��32λ����32��64
set nodejsBit=64
rem ����Ŀ¼
set baseDir=D:\ProgramFiles
rem nodejsĿ¼
set nodeDir=%baseDir%\nodejs
rem nodejs globalĿ¼
set nodeGlobalDir=%nodeDir%\node_global
rem nodejs ����Ŀ¼
set nodeCacheDir=%nodeDir%\node_cache
rem ��ѹ����7z
set zipFile=7za.exe
rem 7z�����ص�ַ
set zipUrl=http://tjn.oss-cn-beijing.aliyuncs.com/7za.exe
rem ˢ�»��������ű�
set refreshenvFile=refreshenv.bat
rem ˢ�»��������ű����ص�ַ
set refreshenvUrl=http://tjn.oss-cn-beijing.aliyuncs.com/refreshenv.bat

rem git��װĿ¼
set gitDir=%baseDir%\Git
rem git���ļ���
set gitExe=git-setup.exe
rem git�����ص�ַ��v2.35.1-x64�汾
set gitUrl=https://registry.npmmirror.com/-/binary/git-for-windows/v2.35.1.windows.2/Git-2.35.1.2-64-bit.exe


rem ����ѹ����7z�Ƿ����
echo - ��ʼ���%zipFile%�Ƿ����
if not exist %zipFile% (
  echo # ȱ��%zipFile%
  echo - ��ʼ����%zipFile%
  
  rem ����powershell�������7z
  powershell -Command "Invoke-WebRequest %zipUrl% -OutFile %zipFile%"
  
  echo �� %zipFile%�������
) else (
  echo # %zipFile%�Ѵ��ڣ���������
)

rem ���ˢ�»��������ű��Ƿ����
echo - ��ʼ���%refreshenvFile%�Ƿ����
if not exist %refreshenvFile% (
  echo # ȱ��%refreshenvFile%
  echo - ��ʼ����%refreshenvFile%
  
  rem ����powershell�������refreshenv.bat
  powershell -Command "Invoke-WebRequest %refreshenvUrl% -OutFile %refreshenvFile%"
  
  echo �� %refreshenvFile%�������
) else (
  echo # %refreshenvFile%�Ѵ��ڣ���������
)

echo - ��ʼ���NodeJs�Ƿ�װ
echo # node -v
call node -v && goto vuecli || goto startNode

:startNode
rem ����nodejs�ļ���
echo - ��ʼ���nodejsĿ¼[%nodeDir%]�Ƿ����
if exist %nodeDir% (
  echo # Ŀ¼[%nodeDir%]�Ѵ��ڣ����贴��
) else (
  mkdir %nodeDir%
  echo �� ����[%nodeDir%]Ŀ¼���
)

rem ����nodejs global Ŀ¼
echo - ��ʼ���nodejs globalĿ¼[%nodeGlobalDir%]�Ƿ����
if exist %nodeGlobalDir% (
  echo # Ŀ¼[%nodeGlobalDir%]�Ѵ��ڣ����贴��
) else (
  mkdir %nodeGlobalDir%
  echo �� ����[%nodeGlobalDir%]Ŀ¼���
)

rem ����nodejs ����Ŀ¼
echo - ��ʼ���nodejs ����Ŀ¼[%nodeCacheDir%]�Ƿ����
if exist %nodeCacheDir% (
  echo # Ŀ¼[%nodeCacheDir%]�Ѵ��ڣ����贴��
) else (
  mkdir %nodeCacheDir%
  echo �� ����[%nodeCacheDir%]Ŀ¼���
)

rem ����������32��ôҪ�滻��������������Ҫ��86������������64λ�汾
if %nodejsBit% == 32 (
  set nodejsBit=86
) else (
  set nodejsBit=64
)
set nodeJsName=node-v%nodejsVersion%-win-x%nodejsBit%
echo - ��ʼ���%nodeJsName%.zip�Ƿ����
if exist %nodeJsName%.zip (
  echo # %nodeJsName%.zip�Ѵ��ڣ���������
  rem ֱ��ȥ��ѹ
  goto :zip
)
echo - ��ʼ����nodejs, ��������%nodeJsName%�汾
rem nodejs�����ص�ַ�����Ա�npm������վ������
set nodejsUrl=https://registry.npmmirror.com/-/binary/node/v%nodejsVersion%/node-v%nodejsVersion%-win-x%nodejsBit%.zip
echo # %nodeJsName%���ص�ַΪ��%nodejsUrl%
rem ����powershell�������nodejs zip
powershell -Command "Invoke-WebRequest %nodejsUrl% -OutFile %nodeJsName%.zip"
echo �� %nodeJsName%�������

:zip
echo - ��ʼ���%nodeJsName%�ļ����Ƿ����
if exist %nodeJsName% (
  echo # %nodeJsName%�ļ����Ѵ��ڣ������ѹ
  rem ֱ��ȥ����
  goto :copy
)
echo - ��ʼ��ѹ%nodeJsName%.zip
rem ����7z�����ѹzip��
7za x %nodeJsName%.zip -y
echo �� %nodeJsName%.zip��ѹ���

:copy
echo - ��ʼ���� [%nodeJsName%] =======�� [%nodeDir%]
rem �ѵ�ǰĿ¼�µ�nodejs���Ƶ�nodejsĿ��Ŀ¼��/q������ʱ����ʾ�ļ���
xcopy %nodeJsName%\*.* %nodeDir% /s /e /c /y /h /r /q
echo �� [%nodeJsName%]�������

rem ϵͳpath·��
set remain=%path%
rem ��������path����nodejs������
set hasNode=false
rem ��������path����nodejs global������
set hasNodeGlobal=false

rem �����������Ƿ���node��node global
echo - ��ʼ���nodejs���������Ƿ����
:loop
for /f "tokens=1* delims=;" %%a in ("%remain%") do (
  if "%nodeDir%"=="%%a" (
    set hasNode=true
    echo # %nodeDir% �Ѵ���Path��
  ) 
   
  if "%nodeGlobalDir%"=="%%a" (
    set hasNodeGlobal=true
    echo # %nodeGlobalDir% �Ѵ���Path��
  )
  
  set remain=%%b
)

rem һֱѭ��
if defined remain goto :loop

rem ���ݲ�ͬ�������ƴ����Ҫ���뵽path�е�·��
set resPath=
if "%hasNode%"=="false" (
  if "%hasNodeGlobal%"=="false" (
    set resPath=%path%;%nodeDir%;%nodeGlobalDir%
  )
  if "%hasNodeGlobal%"=="true" (
    set resPath=%path%;%nodeDir%
  )
)

if "%hasNode%"=="true" (
  if "%hasNodeGlobal%"=="false" (
    set resPath=%path%;%nodeGlobalDir%
  )
  if "%hasNodeGlobal%"=="true" (
    set resPath=
  )
)

rem �����ֵ�ż���д�뻷������path
if defined resPath (
  echo - ��ʼд�뻷������
  setx /m "path" "%resPath%"
  
  rem ���������ʾ�����ˣ�setx�᷵�سɹ���ʧ�ܵ���ʾ
  rem echo �� д�뻷���������
  
  echo - ��ʼˢ�»�������
  rem �����ⲿ�ű���ˢ�»�������
  call refreshenv.bat
  echo �� ˢ�»����������
) else (
  echo # nodejs���������Ѵ��ڣ��������
)

echo # �鿴node�汾
echo # node -v
call node -v

echo # �鿴npm�汾
echo # npm -v
call npm -v

echo - ��ʼ���nodejsȫ��Ŀ¼����
for /F %%i in ('npm config get prefix') do (set prefixInfo=%%i)
if not %prefixInfo% == %nodeGlobalDir% (
  rem ����nodejsȫ��Ŀ¼
  call npm config set prefix "%nodeGlobalDir%"
  echo # npm config set prefix "%nodeGlobalDir%"
  
  call npm config get prefix
  echo �� nodejsȫ��Ŀ¼�������
) else (
  echo # nodejsȫ��Ŀ¼�����ã���������
)

echo - ��ʼ���nodejs����Ŀ¼����
for /F %%i in ('npm config get cache') do (set cacheInfo=%%i)
if not %cacheInfo% == %nodeCacheDir% (
  rem ����nodejs����Ŀ¼
  call npm config set cache "%nodeCacheDir%"
  echo # npm config set cache "%nodeCacheDir%"
  
  call npm config get cache
  echo �� nodejs����Ŀ¼�������
) else (
  echo # nodejs����Ŀ¼�����ã���������
)

echo - ��ʼ���npm���ھ�������
set taobaoNpmUrl=https://registry.npmmirror.com/
for /F %%i in ('npm config get registry') do (set registryInfo=%%i)
if not %registryInfo% == %taobaoNpmUrl% (
  rem ���ù��ھ���Դ
  call npm config set registry %taobaoNpmUrl%
  echo # npm config set registry %taobaoNpmUrl%
  
  call npm config get registry
  echo �� npm���ھ����������
) else (
  echo # npm���ھ��������ã���������
)

:vuecli
echo - ��ʼ����Ƿ�װ��vue-cli
echo # vue -V
call vue -V
if %errorlevel% == 0 (
  echo # vue-cli�Ѱ�װ�������谲װ
  goto :git
)

echo - ��ʼ��װvue-cli
rem ��װvue/cli
call npm i -g @vue/cli
echo �� vue-cli ��װ���

echo # �鿴vue-cli�汾
echo vue -V
call vue -V

if not %errorlevel% == 0 (
  echo # vue-cli��װʧ�ܣ�������������б��ű������·������ֶ���װ
  echo # npm i -g @vue/cli
)

:git
echo.
echo # Ҫ��װGit��(1����װ��2������)
set /p installGit=
echo ��ѡ���ˣ�%installGit%

rem ��ʼ��װgit
if "%installGit%" == "1" (

  echo - ��ʼ����Ƿ�װ��Git
  echo # git --version
  call git --version && goto gitInstalled || goto startInstallGit
  
  rem �Ѿ���װ��git�ˣ�ֱ������
  :gitInstalled
  echo # Git�Ѱ�װ�������谲װ
  goto :done
  
  rem û�а�װ����������git�����ļ������ж��а�װ����
  :startInstallGit
  rem д��git�����ļ�
  (
    echo [Setup]
    echo Lang=default
    echo Dir=%gitDir%
    echo Group=Git
    echo NoIcons=0
    echo SetupType=default
    echo Components=icons,ext\reg\shellhere,assoc,assoc_sh
    echo Tasks=
    echo PathOption=Cmd
    echo SSHOption=OpenSSH
    echo CRLFOption=CRLFAlways
    echo BashTerminalOption=ConHost
    echo PerformanceTweaksFSCache=Enabled
    echo UseCredentialManager=Enabled
    echo EnableSymlinks=Disabled
    echo EnableBuiltinDifftool=Disabled
  ) > config.inf
  
  if not exist %gitExe% (
    echo - %gitExe%�ļ������ڣ���ʼ����Git...
	rem ����powershell�������nodejs zip
    powershell -Command "Invoke-WebRequest %gitUrl% -OutFile %gitExe%"
	echo �� Git�������
  )
  
  echo - ��ʼ��װGit...
  rem ʹ�������ļ���װgit
  call %gitExe% /VERYSILENT /LOADINF="config.inf" && goto gitInstallSuccess || goto gitInstallError
  
  rem git��װʧ�ܣ�ֱ���˳�
  :gitInstallError
  echo �� Git��װʧ�ܣ�������������б��ű��������°�װ������ǰĿ¼��%gitExe%�ֶ���װGit
  goto done
  
  rem git�ɹ��ż���
  :gitInstallSuccess
  echo �� Git��װ�ɹ�
 
  echo - ��ʼˢ�»�������
  rem �����ⲿ�ű���ˢ�»�������
  call refreshenv.bat
  echo �� ˢ�»����������

  echo - �鿴Git�汾
  echo # git --version
  call git --version
  
  
  rem ��ɾ�ˣ����������˿���
  rem del config.inf
)


:done
echo.
echo  -------------- ȫ�����óɹ�����������˳� ------------
pause>nul