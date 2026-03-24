# RTS Demo Signaling Server

WebRTC 信令服务器，用于 Godot RTS Demo 多人游戏的 P2P 连接协商。

## 功能

- 房间管理：配对 Host 和 Client
- 消息中继：转发 WebRTC SDP（Session Description Protocol）和 ICE 候选
- 自动清理：房间为空时自动删除
- 轻量级：仅负责初始握手，不转发游戏数据

## 快速开始

### 本地运行

```bash
npm install
npm start
```

服务器将在 `ws://localhost:8080` 启动。

### 部署到 Railway

1. 创建 GitHub 仓库并推送此代码
2. 访问 [Railway.app](https://railway.app)
3. 点 **New Project** → **Deploy from GitHub Repo**
4. 选择此仓库，点 **Deploy**
5. 在 **Settings → Networking** 中生成域名，形如 `rts-signaling-production.up.railway.app`
6. 在 Godot 游戏中更新连接地址：
   ```gdscript
   @export var signaling_server_url: String = "wss://rts-signaling-production.up.railway.app"
   ```

## 通信协议

### 连接

```
GET /ws?room=AB1234&role=host
GET /ws?room=AB1234&role=client
```

### 消息格式

#### SDP 消息（offer / answer）

```json
{
  "type": "offer",
  "sdp": "v=0\no=..."
}
```

```json
{
  "type": "answer",
  "sdp": "v=0\no=..."
}
```

#### ICE 候选消息

```json
{
  "type": "ice_candidate",
  "candidate": "candidate:...",
  "sdp_mid": "0",
  "sdp_m_line_index": 0
}
```

## 文件结构

```
.
├── server.js          # 主服务器文件
├── package.json       # Node.js 依赖
└── README.md          # 此文件
```

## 依赖

- [ws](https://github.com/websockets/ws)：WebSocket 库

## 注意事项

- 信令服务器只负责初始握手，游戏数据通过 WebRTC P2P 直连
- Railway 免费计划足够支持此服务（500 小时/月）
- 生产环境建议添加认证和日志监控

## 许可

MIT
