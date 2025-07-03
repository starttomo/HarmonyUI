import http from '@ohos.net.http';

export class BackendService {


  static fetchHerbList(searchText: string = '', category: string = 'all'): Promise<any[]> {
    return new Promise((resolve, reject) => {
      let url = `http://192.168.223.223:8081/api/herbs?search=${encodeURIComponent(searchText)}&category=${encodeURIComponent(category)}`;
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

  static toggleLike(id: number, like: boolean): Promise<void> {
    return new Promise((resolve, reject) => {
      let url = `http://192.168.223.223:8081/api/herbs/${id}/like`;
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify({ like })
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

  static toggleCollect(id: number, collect: boolean): Promise<void> {
    return new Promise((resolve, reject) => {
      let url = `http://192.168.223.223:8081/api/herbs/${id}/collect`;
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify({ collect })
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

}