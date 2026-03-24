@echo off
REM RTS Signaling Server - GitHub 推送脚本 (Windows)

REM 设置变量（请修改为你的信息）
set GITHUB_USERNAME=your-username
set REPO_NAME=rts-signaling

REM 第一步：进入目录
cd signaling-server
echo.
echo 📁 进入 signaling-server 目录...

REM 检查是否已经是 git 仓库
if exist ".git" (
  echo ⚠️  已经是 git 仓库，跳过 git init
) else (
  echo 🔧 初始化 git 仓库...
  git init
)

REM 第二步：添加所有文件
echo.
echo 📝 添加所有文件到暂存区...
git add .

REM 第三步：创建提交
echo.
echo 💾 创建提交...
git commit -m "Initial commit: WebRTC signaling server for RTS demo"

REM 第四步：添加远程仓库
echo.
echo 🔗 添加远程仓库...
set REMOTE_URL=https://github.com/%GITHUB_USERNAME%/%REPO_NAME%.git

REM 检查是否已经有远程
git remote get-url origin >nul 2>&1
if %errorlevel% equ 0 (
  echo ⚠️  远程仓库已存在，跳过 git remote add
) else (
  git remote add origin %REMOTE_URL%
)

REM 第五步：推送到 GitHub
echo.
echo 🚀 推送到 GitHub (需要输入 GitHub 凭证)...
git push -u origin main

echo.
echo ✅ 完成！
echo 📍 仓库地址: %REMOTE_URL%
echo.
pause
