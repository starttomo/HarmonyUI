// Profile.ets
import router from '@ohos.router';
import prompt from '@system.prompt';
import preferences from '@ohos.data.preferences';
import { verifyToken } from '../utils/UserData';
import { BottomTabs } from '../components/BottomTabs';
import image from '@ohos.multimedia.image';
import {BackendService} from '../services/BackendService';
@Entry
@Component
struct Profile {
  @State isLoggedIn: boolean = false;
  @State username: string = '';
  @State userId: number = 0;
  //@State avatar: string = '../imgs/user.png';
  @State browseHistory: Array<{
    id: number,
    name: string,
    views: number,
    time: string
  }> = [];

  @State likedHerbs: Array<{
    id: number,
    name: string,
    image: string,
    time: string
  }> = [];

  @State collectedHerbs: Array<{
    id: number,
    name: string,
    image: string,
    time: string
  }> = [];

  @State commentedHerbs: Array<{
    id: number,
    name: string,
    content: string,
    time: string
  }> = [];

  async aboutToAppear() {
    console.log('Profile aboutToAppear');
    try {
      // Load token, username, userId from preferences
      const context = getContext(this);
      const pref = await preferences.getPreferences(context, 'user_token');
      const tokenValue = await pref.get('token', '');
      const usernameValue = await pref.get('username', '');
      const userIdValue = await pref.get('user_id', 0);

      const token = typeof tokenValue === 'string' ? tokenValue : '';
      const storedUsername = typeof usernameValue === 'string' ? usernameValue : '';
      const storedUserId = Number(userIdValue);
      console.log('Profile aboutToAppear userId:', storedUserId, 'isLoggedIn:', token && storedUsername && storedUserId > 0);

      if (token && storedUsername && storedUserId > 0) {
        this.username = storedUsername;
        this.isLoggedIn = true;
        this.userId = storedUserId;
        // 登录后加载真实数据
        await this.loadUserData();
      } else {
        this.isLoggedIn = false;
        this.username = '';
        this.userId = 0;
        // 未登录时加载模拟数据
        this.loadMockData();
      }
    } catch (err) {
      console.error('加载用户信息失败:', err);
      this.isLoggedIn = false;
      const currentRoute = router.getState()?.name;
      if (currentRoute !== 'Login') {
        await router.replaceUrl({ url: 'pages/Login' });
        prompt.showToast({ message: '加载用户信息失败，请重新登录' });
      }
    }
  }

  async loadUserData() {
    console.log('loadUserData start, userId:', this.userId);
    // 加载用户历史、点赞、收藏、评论
    try {
      this.browseHistory = await BackendService.fetchUserHistory(this.userId);
      console.log('browseHistory:', this.browseHistory);
    } catch (e) {
      console.log('fetchUserHistory error:', e);
      this.browseHistory = [];
    }
    try {
      const likes = await BackendService.fetchUserLikes(this.userId);
      this.likedHerbs = Array.isArray(likes) ? likes.map(item => ({
        id: item.herb_id,
        name: item.herb_name,
        image: item.image,
        time: item.create_time
      })) : [];
    } catch (e) {
      this.likedHerbs = [];
    }
    try {
      const collects = await BackendService.fetchUserCollections(this.userId);
      this.collectedHerbs = Array.isArray(collects) ? collects.map(item => ({
        id: item.herb_id,
        name: item.herb_name,
        image: item.image,
        time: item.create_time
      })) : [];
    } catch (e) {
      this.collectedHerbs = [];
    }
    try {
      this.commentedHerbs = await BackendService.fetchUserComments(this.userId);
      console.log('commentedHerbs:', this.commentedHerbs);
    } catch (e) {
      console.log('fetchUserComments error:', e);
      this.commentedHerbs = [];
    }
  }

  loadMockData() {
    this.browseHistory = [
      { id: 1, name: '当归', views: 120, time: '2023-10-15 14:30' },
      { id: 2, name: '黄芪', views: 95, time: '2023-10-14 09:15' },
      { id: 3, name: '人参', views: 200, time: '2023-10-12 16:45' }
    ];

    this.likedHerbs = [
      { id: 1, name: '当归', image: '/resources/base/media/congbai.jpg', time: '2023-10-15 14:32' },
      { id: 2, name: '黄芪', image: '/resources/base/media/3.jpg', time: '2023-10-14 09:17' }
    ];

    this.collectedHerbs = [
      { id: 1, name: '当归', image: '/resources/base/media/congbai.jpg', time: '2023-10-15 14:35' },
      { id: 3, name: '人参', image: '/resources/base/media/3.jpg', time: '2023-10-12 16:50' }
    ];

    this.commentedHerbs = [
      { id: 1, name: '当归', content: '这个中药效果很好，推荐使用！', time: '2023-10-15 14:40' },
      { id: 2, name: '黄芪', content: '补气效果不错，但味道有点苦', time: '2023-10-14 09:20' }
    ];
  }

  onPageShow() {
    console.log('Profile onPageShow', 'isLoggedIn:', this.isLoggedIn, 'userId:', this.userId);
    if (this.isLoggedIn && this.userId > 0) {
      this.loadUserData();
    }
  }

  build() {
    Column() {
      // 主内容区域 - 使用Scroll确保内容可滚动
      Scroll() {
        Column() {
          // 用户头像区域
          Column() {
            Image($r("app.media.user"))
              .width(150)
              .height(150)
              .borderRadius(50)
              .margin({ bottom: 10 })

            if (this.isLoggedIn) {
              // 登录后显示用户名
              Text(this.username)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 10 })
              // 退出登录按钮
              Button('退出登录', { type: ButtonType.Capsule })
                .onClick(async () => {
                  try {
                    // Clear preferences
                    const context = getContext(this);
                    const pref = await preferences.getPreferences(context, 'user_token');
                    await pref.clear();
                    await pref.flush();
                    this.isLoggedIn = false;
                    this.username = '';
                    this.userId = 0;
                    // 退出后加载模拟数据
                    this.loadMockData();
                    // Redirect to Login page
                    await router.replaceUrl({ url: 'pages/Login' });
                    prompt.showToast({ message: '已退出登录' });
                  } catch (err) {
                    console.error('退出登录失败:', err);
                    prompt.showToast({ message: '退出登录失败，请稍后再试' });
                  }
                })
                .width(120)
                .height(40)
            } else {
              // 未登录只显示登录按钮
              Button('点击登录', { type: ButtonType.Capsule })
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/Login',
                    params: { from: 'profile' }
                  }).then(() => {
                    // 登录成功后返回 will trigger aboutToAppear
                  }).catch(err => {
                    prompt.showToast({ message: '跳转登录页面失败' });
                  });
                })
                .width(120)
                .height(40)
            }
          }
          .width('100%')
          .padding(20)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .border({ width: 1, color: '#F0F0F0' })

          // 浏览记录
          Column() {
            Row() {
              Text('浏览记录')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)

              Text('查看更多')
                .fontSize(14)
                .fontColor('#008000')
                .margin({ left: 10 })
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/BrowseHistory'
                  });
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ bottom: 10 })

            // 仅在有数据时渲染条目
            if (this.browseHistory.length > 0) {
              ForEach(this.browseHistory, (item) => {
                Row() {
                  Text(item.name)
                    .fontSize(16)
                    .layoutWeight(1)

                  Text(`浏览量: ${item.views}`)
                    .fontSize(14)
                    .fontColor('#666666')
                }
                .width('100%')
                .padding(10)
                .borderRadius(8)
                .backgroundColor('#F5F5F5')
                .margin({ bottom: 8 })
              })
            }
          }
          .width('90%')
          .margin({ top: 20 })

          // 点赞过的中药
          Column() {
            Text('点赞过的中药')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 10 })

            if (this.likedHerbs.length > 0) {
              ForEach(this.likedHerbs, (item) => {
                Row() {
                  Text(item.name)
                    .fontSize(16)
                    .layoutWeight(1)
                  Image(item.image)
                    .width(32)
                    .height(32)
                    .borderRadius(8)
                }
                .width('100%')
                .padding(10)
                .borderRadius(8)
                .backgroundColor('#F5F5F5')
                .margin({ bottom: 8 })
                .onClick(() => {
                  prompt.showDialog({
                    title: `点赞信息 (${item.name})`,
                    message: `药材名称: ${item.name}\n点赞时间: ${item.time}`,
                    buttons: [{ text: '确定', color: '#000000' }]
                  });
                })
              }, item => item.id)
            }
          }
          .width('90%')
          .margin({ top: 20 })

          // 收藏过的中药
          Column() {
            Text('收藏过的中药')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 10 })

            if (this.collectedHerbs.length > 0) {
              ForEach(this.collectedHerbs, (item) => {
                Row() {
                  Text(item.name)
                    .fontSize(16)
                    .layoutWeight(1)
                  Image(item.image)
                    .width(32)
                    .height(32)
                    .borderRadius(8)
                }
                .width('100%')
                .padding(10)
                .borderRadius(8)
                .backgroundColor('#F5F5F5')
                .margin({ bottom: 8 })
                .onClick(() => {
                  prompt.showDialog({
                    title: `收藏信息 (${item.name})`,
                    message: `药材名称: ${item.name}\n收藏时间: ${item.time}`,
                    buttons: [{ text: '确定', color: '#000000' }]
                  });
                })
              }, item => item.id)
            }
          }
          .width('90%')
          .margin({ top: 20 })

          // 评论过的中药
          Column() {
            Text('评论过的中药')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 10 })

            if (this.commentedHerbs.length > 0) {
              ForEach(this.commentedHerbs, (item) => {
                Column() {
                  Row() {
                    Text(item.name)
                      .fontSize(16)
                      .layoutWeight(1)
                  }
                  .width('100%')
                  .padding(10)
                  .onClick(() => {
                    prompt.showDialog({
                      title: `评论内容 (${item.name})`,
                      message: `${item.content}\n\n评论时间: ${item.time}`,
                      buttons: [
                        {
                          text: '确定',
                          color: '#000000'
                        }
                      ]
                    });
                  })
                }
                .width('100%')
                .borderRadius(8)
                .backgroundColor('#F5F5F5')
                .margin({ bottom: 8 })
              })
            }
          }
          .width('90%')
          .margin({ top: 20, bottom: 30 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .layoutWeight(1)
      .width('100%')

      // 底部导航栏
      BottomTabs()
    }
    .width('100%')
    .height('100%')
  }
}