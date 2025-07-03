import http from '@ohos.net.http';

export class BackendService {


  static fetchHerbList(searchText: string = '', category: string = 'all', userId: number = 0): Promise<any[]> {
    return new Promise((resolve, reject) => {
      let url = `http://192.168.223.223:8081/api/herbs?search=${encodeURIComponent(searchText)}&category=${encodeURIComponent(category)}`;
      if (userId && userId > 0) {
        url += `&user_id=${userId}`;
      }
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

  static fetchHerbDetail(id: number): Promise<any> {
    return new Promise((resolve, reject) => {
      let url = `http://192.168.223.223:8081/api/herbs/${id}`;
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
      let url = `http://192.168.223.223:8081/api/herbs/${id}/like`;
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
      let url = `http://192.168.223.223:8081/api/herbs/${id}/collect`;
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
      let url = 'http://192.168.223.223:8081/api/login';
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
      let url = `http://192.168.223.223:8081/api/user/${userId}/history`;
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
      let url = `http://192.168.223.223:8081/api/user/${userId}/likes`;
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
      let url = `http://192.168.223.223:8081/api/user/${userId}/collections`;
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
      let url = `http://192.168.223.223:8081/api/user/${userId}/comments`;
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
      let url = `http://192.168.223.223:8081/api/herbs/${id}/view`;
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

}