// 模拟登录 API
export async function login(data: { account: string; password: string }) {
  // 这里可以替换为实际的网络请求
  return new Promise((resolve) => {
    setTimeout(() => {
      // 模拟登录成功
      const response = {
        data: {
          data: 'mocked_token'
        }
      };
      resolve(response);
    }, 1000);
  });
}