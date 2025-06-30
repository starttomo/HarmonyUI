// userData.ts
// 模拟数据库
const users: { [username: string]: { password: string; token: string | null } } = {
  admin: { password: '123456', token: null }
};

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
function registerUser(username: string, password: string): boolean {
  if (users[username]) {
    return false; // 用户已存在
  }
  users[username] = { password, token: null };
  return true;
}

// 用户登录
async function loginUser(username: string, password: string): Promise<string | null> {
  const user = users[username];
  if (user && user.password === password) {
    const token = await generateToken();
    user.token = token;
    return token;
  }
  return null;
}

// 验证 token
function verifyToken(username: string, token: string): boolean {
  const user = users[username];
  return user && user.token === token;
}

export { registerUser, loginUser, verifyToken };