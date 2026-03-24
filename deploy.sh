#!/bin/bash
# RTS Signaling Server - GitHub 推送脚本

# 设置变量（请修改为你的信息）
GITHUB_USERNAME="your-username"  # 改为你的 GitHub 用户名
REPO_NAME="rts-signaling"

# 第一步：初始化 git 仓库
cd signaling-server
echo "📁 进入 signaling-server 目录..."

# 检查是否已经是 git 仓库
if [ -d ".git" ]; then
  echo "⚠️  已经是 git 仓库，跳过 git init"
else
  echo "🔧 初始化 git 仓库..."
  git init
fi

# 第二步：添加所有文件
echo "📝 添加所有文件到暂存区..."
git add .

# 第三步：创建提交
echo "💾 创建提交..."
git commit -m "Initial commit: WebRTC signaling server for RTS demo"

# 第四步：添加远程仓库
echo "🔗 添加远程仓库..."
REMOTE_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
git remote add origin $REMOTE_URL

# 第五步：推送到 GitHub
echo "🚀 推送到 GitHub..."
git push -u origin main

echo "✅ 完成！"
echo "📍 仓库地址: $REMOTE_URL"
