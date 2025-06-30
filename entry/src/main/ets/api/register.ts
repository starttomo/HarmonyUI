// 模拟注册 API
export async function register(data: { account: string; password: string }) {
  // 这里可以替换为实际的网络请求
  return new Promise((resolve) => {
    setTimeout(() => {
      // 模拟注册成功
      const response = {
        data: {
          success: true
        }
      };
      resolve(response);
    }, 1000);
  });
}