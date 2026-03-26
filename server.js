import WebSocket, { WebSocketServer } from 'ws';
import http from 'http';
import url from 'url';

const PORT = process.env.PORT || 8080;

// 房间管理: { roomId: { host: ws, client: ws } }
const rooms = new Map();

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Signaling server OK. Rooms: ' + rooms.size);
});
const wss = new WebSocketServer({ server });

wss.on('connection', (ws, req) => {
  const params = new url.URLSearchParams(url.parse(req.url).query);
  const roomId = params.get('room');
  const role = params.get('role'); // 'host' 或 'client'

  if (!roomId || !role) {
    ws.close(1008, 'Missing room or role parameter');
    return;
  }

  console.log(`[${roomId}] ${role} connected`);

  // 初始化或获取房间
  if (!rooms.has(roomId)) {
    rooms.set(roomId, { host: null, client: null });
  }

  const room = rooms.get(roomId);

  // 检查房间是否已满
  if (room[role] !== null) {
    ws.close(1008, 'Role already occupied in this room');
    return;
  }

  room[role] = ws;

  // 消息转发逻辑
  ws.on('message', (data) => {
    try {
      const msg = JSON.parse(data.toString());
      const peer = role === 'host' ? room.client : room.host;

      if (peer && peer.readyState === WebSocket.OPEN) {
        peer.send(JSON.stringify(msg));
      }
    } catch (err) {
      console.error(`[${roomId}] Message error:`, err.message);
    }
  });

  ws.on('close', () => {
    console.log(`[${roomId}] ${role} disconnected`);
    room[role] = null;

    // 如果房间为空，删除它
    if (room.host === null && room.client === null) {
      rooms.delete(roomId);
      console.log(`[${roomId}] Room deleted`);
    } else if (room.host !== null && room.host.readyState === WebSocket.OPEN) {
      // 通知另一方对方已断开
      room.host.send(JSON.stringify({ type: 'peer_disconnected' }));
    } else if (room.client !== null && room.client.readyState === WebSocket.OPEN) {
      room.client.send(JSON.stringify({ type: 'peer_disconnected' }));
    }
  });

  ws.on('error', (err) => {
    console.error(`[${roomId}] ${role} error:`, err.message);
  });
});

server.listen(PORT, () => {
  console.log(`Signaling server running on port ${PORT}`);
});
