import http from '@ohos.net.http';

export class BackendService {


  static fetchHerbList(searchText: string = '', category: string = 'all', userId: number = 0): Promise<any[]> {
    return new Promise((resolve, reject) => {
      // let url = `http://192.168.223.223:8081/api/herbs?search=${encodeURIComponent(searchText)}&category=${encodeURIComponent(category)}`;
      let url = `http://192.168.212.223:8081/api/herbs?search=${encodeURIComponent(searchText)}&category=${encodeURIComponent(category)}`;
      if (userId && userId > 0) {
        url += `&user_id=${userId}`;
      }
      console.log(`BackendService: 发起HTTP请求到 ${url}`);
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' },
          connectTimeout: 10000,  // 10秒连接超时
          readTimeout: 10000      // 10秒读取超时
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            console.error('BackendService: HTTP请求错误:', err);
            console.error('错误代码:', err.code);
            console.error('错误消息:', err.message);
            reject(err);
          } else {
            try {
              console.log('BackendService: 收到响应，状态码:', data.responseCode);
              console.log('BackendService: 响应数据长度:', data.result.toString().length);
              console.log('BackendService: 响应数据前100字符:', data.result.toString().substring(0, 100));
              resolve(JSON.parse(data.result.toString()));
            } catch (e) {
              console.error('BackendService: JSON解析错误:', e);
              console.error('BackendService: 原始响应数据:', data.result.toString());
              reject(e);
            }
          }
        }
      );
    });
  }

  static fetchHerbDetail(id: number): Promise<any> {
    return new Promise((resolve, reject) => {
      // let url = `http://192.168.223.223:8081/api/herbs/${id}`;
      let url = `http://192.168.212.223:8081/api/herbs/${id}`;
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' }
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            reject(err);
          } else {
            try {
              resolve(JSON.parse(data.result.toString()));
            } catch (e) {
              reject(e);
            }
          }
        }
      );
    });
  }

  static toggleLike(id: number, like: boolean, userId: number): Promise<void> {
    return new Promise((resolve, reject) => {
      // let url = `http://192.168.223.223:8081/api/herbs/${id}/like`;
      let url = `http://192.168.212.223:8081/api/herbs/${id}/like`;
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify({ like, user_id: userId })
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            reject(err);
          } else {
            resolve();
          }
        }
      );
    });
  }

  static toggleCollect(id: number, collect: boolean, userId: number): Promise<void> {
    return new Promise((resolve, reject) => {
      // let url = `http://192.168.223.223:8081/api/herbs/${id}/collect`;
      let url = `http://192.168.212.223:8081/api/herbs/${id}/collect`;
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify({ collect, user_id: userId })
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            reject(err);
          } else {
            resolve();
          }
        }
      );
    });
  }

  static login(username: string, password: string): Promise<any> {
    return new Promise((resolve, reject) => {
      // let url = 'http://192.168.223.223:8081/api/login';
      let url = 'http://192.168.212.223:8081/api/login';
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify({ username, password })
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            reject(err);
          } else {
            try {
              resolve(JSON.parse(data.result.toString()));
            } catch (e) {
              reject(e);
            }
          }
        }
      );
    });
  }

  // 获取用户浏览历史
  static fetchUserHistory(userId: number): Promise<any[]> {
    return new Promise((resolve, reject) => {
      // let url = `http://192.168.223.223:8081/api/user/${userId}/history`;
      let url = `http://192.168.212.223:8081/api/user/${userId}/history`;
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' }
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            reject(err);
          } else {
            try {
              resolve(JSON.parse(data.result.toString()));
            } catch (e) {
              reject(e);
            }
          }
        }
      );
    });
  }

  // 获取用户点赞的中药
  static fetchUserLikes(userId: number): Promise<any[]> {
    return new Promise((resolve, reject) => {
      // let url = `http://192.168.223.223:8081/api/user/${userId}/likes`;
      let url = `http://192.168.212.223:8081/api/user/${userId}/likes`;
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' }
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            reject(err);
          } else {
            try {
              const arr = JSON.parse(data.result.toString());
              resolve(arr.map(item => ({
                herb_id: item.herb_id,
                herb_name: item.herb_name,
                image: item.image_url,
                create_time: item.create_time
              })));
            } catch (e) {
              reject(e);
            }
          }
        }
      );
    });
  }

  // 获取用户收藏的中药
  static fetchUserCollections(userId: number): Promise<any[]> {
    return new Promise((resolve, reject) => {
      // let url = `http://192.168.223.223:8081/api/user/${userId}/collections`;
      let url = `http://192.168.212.223:8081/api/user/${userId}/collections`;
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' }
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            reject(err);
          } else {
            try {
              const arr = JSON.parse(data.result.toString());
              resolve(arr.map(item => ({
                herb_id: item.herb_id,
                herb_name: item.herb_name,
                image: item.image_url,
                create_time: item.create_time
              })));
            } catch (e) {
              reject(e);
            }
          }
        }
      );
    });
  }

  // 获取用户评论的中药
  static fetchUserComments(userId: number): Promise<any[]> {
    return new Promise((resolve, reject) => {
      // let url = `http://192.168.223.223:8081/api/user/${userId}/comments`;
      let url = `http://192.168.212.223:8081/api/user/${userId}/comments`;
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' }
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            reject(err);
          } else {
            try {
              resolve(JSON.parse(data.result.toString()));
            } catch (e) {
              reject(e);
            }
          }
        }
      );
    });
  }

  // 浏览量+1
  static addView(id: number, userId: number): Promise<void> {
    return new Promise((resolve, reject) => {
      // let url = `http://192.168.223.223:8081/api/herbs/${id}/view`;
      let url = `http://192.168.212.223:8081/api/herbs/${id}/view`;
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify({ user_id: userId })
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            reject(err);
          } else {
            resolve();
          }
        }
      );
    });
  }

  // 测试网络连接
  static testConnection(): Promise<boolean> {
    return new Promise((resolve, reject) => {
      let url = 'http://192.168.212.223:8081/api/herbs';
      console.log(`测试连接到: ${url}`);
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' },
          connectTimeout: 5000,   // 5秒连接超时
          readTimeout: 5000       // 5秒读取超时
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            console.error('连接测试失败:', err);
            resolve(false);
          } else {
            console.log('连接测试成功，状态码:', data.responseCode);
            resolve(true);
          }
        }
      );
    });
  }

  // ==================== 视频相关API ====================

  // 获取视频列表
  static fetchVideoList(userId: number = 0): Promise<any[]> {
    console.log('fetchVideoList参数:', userId, new Error().stack);
    return new Promise((resolve, reject) => {
      let url = `http://192.168.212.223:8081/api/videos`;
      if (userId && userId > 0) {
        url += `?user_id=${userId}`;
      }
      console.log(`获取视频列表: ${url}`);
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' },
          connectTimeout: 10000,
          readTimeout: 10000
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            console.error('获取视频列表失败:', err);
            reject(err);
          } else {
            try {
              console.log('视频列表响应状态码:', data.responseCode);
              const videos = JSON.parse(data.result.toString());
              console.log(`获取到 ${videos.length} 个视频`);
              resolve(videos);
            } catch (e) {
              console.error('视频列表JSON解析错误:', e);
              reject(e);
            }
          }
        }
      );
    });
  }

  // 获取视频详情
  static fetchVideoDetail(id: number): Promise<any> {
    return new Promise((resolve, reject) => {
      let url = `http://192.168.212.223:8081/api/videos/${id}`;
      console.log(`获取视频详情: ${url}`);
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' },
          connectTimeout: 10000,
          readTimeout: 10000
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            console.error('获取视频详情失败:', err);
            reject(err);
          } else {
            try {
              resolve(JSON.parse(data.result.toString()));
            } catch (e) {
              console.error('视频详情JSON解析错误:', e);
              reject(e);
            }
          }
        }
      );
    });
  }

  // 视频点赞/取消点赞
  static toggleVideoLike(id: number, like: boolean, userId: number): Promise<void> {
    return new Promise((resolve, reject) => {
      let url = `http://192.168.212.223:8081/api/videos/${id}/like`;
      console.log(`视频点赞操作: ${url}, like: ${like}`);
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify({ like, user_id: userId }),
          connectTimeout: 10000,
          readTimeout: 10000
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            console.error('视频点赞操作失败:', err);
            reject(err);
          } else {
            console.log('视频点赞操作成功');
            resolve();
          }
        }
      );
    });
  }

  // 视频收藏/取消收藏
  static toggleVideoCollect(id: number, collect: boolean, userId: number): Promise<void> {
    return new Promise((resolve, reject) => {
      let url = `http://192.168.212.223:8081/api/videos/${id}/collect`;
      console.log(`视频收藏操作: ${url}, collect: ${collect}`);
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify({ collect, user_id: userId }),
          connectTimeout: 10000,
          readTimeout: 10000
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            console.error('视频收藏操作失败:', err);
            reject(err);
          } else {
            console.log('视频收藏操作成功');
            resolve();
          }
        }
      );
    });
  }

  // 视频播放量+1
  static addVideoView(id: number, userId: number): Promise<void> {
    return new Promise((resolve, reject) => {
      let url = `http://192.168.212.223:8081/api/videos/${id}/view`;
      console.log(`视频播放量+1: ${url}`);
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify({ user_id: userId }),
          connectTimeout: 10000,
          readTimeout: 10000
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            console.error('视频播放量更新失败:', err);
            reject(err);
          } else {
            console.log('视频播放量更新成功');
            resolve();
          }
        }
      );
    });
  }

  // 获取视频评论列表
  static fetchVideoComments(videoId: number): Promise<any[]> {
    return new Promise((resolve, reject) => {
      let url = `http://192.168.212.223:8081/api/videos/${videoId}/comments`;
      console.log(`获取视频评论: ${url}`);
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' },
          connectTimeout: 10000,
          readTimeout: 10000
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            console.error('获取视频评论失败:', err);
            reject(err);
          } else {
            try {
              const comments = JSON.parse(data.result.toString());
              console.log(`获取到 ${comments.length} 条评论`);
              resolve(comments);
            } catch (e) {
              console.error('视频评论JSON解析错误:', e);
              reject(e);
            }
          }
        }
      );
    });
  }

  // 添加视频评论
  static addVideoComment(videoId: number, content: string, userId: number): Promise<void> {
    return new Promise((resolve, reject) => {
      let url = `http://192.168.212.223:8081/api/videos/${videoId}/comment`;
      console.log(`添加视频评论: ${url}`);
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify({ content, user_id: userId }),
          connectTimeout: 10000,
          readTimeout: 10000
        },
        (err, data) => {
          httpRequest.destroy();
          if (err) {
            console.error('添加视频评论失败:', err);
            reject(err);
          } else {
            console.log('添加视频评论成功');
            resolve();
          }
        }
      );
    });
  }

  // 验证视频URL，如果无效则使用默认视频
  private validateVideoUrl(videoUrl: string): string | Resource {
    if (!videoUrl || videoUrl.trim() === '') {
      return $rawfile('videox.mp4');
    }
    // 允许网络视频
    if (videoUrl.startsWith('http')) {
      return videoUrl;
    }
    // 其他情况
    return videoUrl;
  }


}