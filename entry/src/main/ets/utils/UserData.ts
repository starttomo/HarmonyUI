// userData.ts
// 模拟数据库
const users: { [username: string]: { password: string; token: string | null } } = {
  admin: { password: '123456', token: null }
};

import http from '@ohos.net.http';

// 生成 token
async function generateToken(): Promise<string> {
  try {
    // Generate a simple random token using Math.random
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let token = '';
    for (let i = 0; i < 16; i++) {
      token += characters.charAt(Math.floor(Math.random() * characters.length));
    }
    return token;
  } catch (error) {
    console.error('生成 token 出错:', error);
    throw new Error('生成 token 失败');
  }
}

// 注册用户
export function registerUser(username: string, password: string, phone: string, email: string, gender: number): Promise<boolean> {
  return new Promise((resolve, reject) => {
    let httpRequest = http.createHttp();
    httpRequest.request(
      'http://192.168.212.223:8081/api/register',
      {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json' },
        extraData: JSON.stringify({ username, password, phone, email, gender })
      },
      (err, data) => {
        httpRequest.destroy();
        if (err) {
          console.error('注册请求错误:', err);
          console.error('错误代码:', err.code);
          console.error('错误消息:', err.message);
          reject(err);
        } else {
          try {
            console.log('注册响应状态码:', data.responseCode);
            console.log('注册响应数据:', data.result.toString());
            const res = JSON.parse(data.result.toString());
            resolve(res.success === true);
          } catch (e) {
            console.error('注册JSON解析错误:', e);
            console.error('原始响应数据:', data.result.toString());
            reject(e);
          }
        }
      }
    );
  });
}

// 用户登录
export function loginUser(username: string, password: string): Promise<any> {
  return new Promise((resolve, reject) => {
    let httpRequest = http.createHttp();
    httpRequest.request(
      'http://192.168.212.223:8081/api/login',
      {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json' },
        extraData: JSON.stringify({ username, password })
      },
      (err, data) => {
        httpRequest.destroy();
        if (err) {
          console.error('登录请求错误:', err);
          console.error('错误代码:', err.code);
          console.error('错误消息:', err.message);
          reject(err);
        } else {
          try {
            console.log('登录响应状态码:', data.responseCode);
            console.log('登录响应数据:', data.result.toString());
            const res = JSON.parse(data.result.toString());
            resolve(res); // 返回完整响应
          } catch (e) {
            console.error('登录JSON解析错误:', e);
            console.error('原始响应数据:', data.result.toString());
            reject(e);
          }
        }
      }
    );
  });
}

// 验证 token
function verifyToken(username: string, token: string): boolean {
  const user = users[username];
  return user && user.token === token;
}

export { verifyToken };