export class BackendService {
  static async toggleLike(id: number, liked: boolean): Promise<void> {
    // 模拟后端请求
    console.log(`Toggle like for content ${id}: ${liked}`);
    return new Promise((resolve) => {
      setTimeout(() => resolve(), 500); // 模拟网络延迟
    });
  }

  static async toggleCollect(id: number, collected: boolean): Promise<void> {
    // 模拟后端请求
    console.log(`Toggle collect for content ${id}: ${collected}`);
    return new Promise((resolve) => {
      setTimeout(() => resolve(), 500); // 模拟网络延迟
    });
  }
}