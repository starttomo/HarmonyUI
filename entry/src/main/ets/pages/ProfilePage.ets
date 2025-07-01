// Profile.ets
import router from '@ohos.router';
import prompt from '@system.prompt';
import preferences from '@ohos.data.preferences';
import { verifyToken } from '../utils/UserData';
import { BottomTabs } from '../components/BottomTabs';
import image from '@ohos.multimedia.image';
@Entry
@Component
struct Profile {
  @State isLoggedIn: boolean = false;
  @State username: string = '';
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
    time: string,
    expanded: boolean
  }> = [];

  @State collectedHerbs: Array<{
    id: number,
    name: string,
    time: string,
    expanded: boolean
  }> = [];

  @State commentedHerbs: Array<{
    id: number,
    name: string,
    content: string,
    time: string
  }> = [];

  async aboutToAppear() {
    try {
      // Load token and username from preferences
      const context = getContext(this);
      const pref = await preferences.getPreferences(context, 'user_token');
      const tokenValue = await pref.get('token', '');
      const usernameValue = await pref.get('username', '');

      // Ensure token and username are strings
      const token = typeof tokenValue === 'string' ? tokenValue : '';
      const storedUsername = typeof usernameValue === 'string' ? usernameValue : '';

      if (token && storedUsername && verifyToken(storedUsername, token)) {
        this.username = storedUsername;
        this.isLoggedIn = true;
      } else {
        this.isLoggedIn = false;
      }

      // Load mock data (unchanged)
      this.loadMockData();
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

  loadMockData() {
    this.browseHistory = [
      { id: 1, name: '当归', views: 120, time: '2023-10-15 14:30' },
      { id: 2, name: '黄芪', views: 95, time: '2023-10-14 09:15' },
      { id: 3, name: '人参', views: 200, time: '2023-10-12 16:45' }
    ];

    this.likedHerbs = [
      { id: 1, name: '当归', time: '2023-10-15 14:32', expanded: false },
      { id: 2, name: '黄芪', time: '2023-10-14 09:17', expanded: false }
    ];

    this.collectedHerbs = [
      { id: 1, name: '当归', time: '2023-10-15 14:35', expanded: false },
      { id: 3, name: '人参', time: '2023-10-12 16:50', expanded: false }
    ];

    this.commentedHerbs = [
      { id: 1, name: '当归', content: '这个中药效果很好，推荐使用！', time: '2023-10-15 14:40' },
      { id: 2, name: '黄芪', content: '补气效果不错，但味道有点苦', time: '2023-10-14 09:20' }
    ];
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
          .width('90%')
          .margin({ top: 20 })

          // 点赞过的中药
          Column() {
            Text('点赞过的中药')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 10 })

            ForEach(this.likedHerbs, (item) => {
              Column() {
                Row() {
                  Text(item.name)
                    .fontSize(16)
                    .layoutWeight(1)

                  Image(item.expanded ? $r("app.media.congbai") :$r("app.media.3") )
                    .width(20)
                    .height(20)
                }
                .width('100%')
                .padding(10)
                .onClick(() => {
                  item.expanded = !item.expanded;
                })

                if (item.expanded) {
                  Text(`点赞时间: ${item.time}`)
                    .fontSize(14)
                    .fontColor('#666666')
                    .margin({ left: 10, bottom: 10 })
                }
              }
              .width('100%')
              .borderRadius(8)
              .backgroundColor('#F5F5F5')
              .margin({ bottom: 8 })
            })
          }
          .width('90%')
          .margin({ top: 20 })

          // 收藏过的中药
          Column() {
            Text('收藏过的中药')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 10 })

            ForEach(this.collectedHerbs, (item) => {
              Column() {
                Row() {
                  Text(item.name)
                    .fontSize(16)
                    .layoutWeight(1)

                  Image(item.expanded ? 'common/icons/arrow_up.png' : 'common/icons/arrow_down.png')
                    .width(20)
                    .height(20)
                }
                .width('100%')
                .padding(10)
                .onClick(() => {
                  item.expanded = !item.expanded;
                })

                if (item.expanded) {
                  Text(`收藏时间: ${item.time}`)
                    .fontSize(14)
                    .fontColor('#666666')
                    .margin({ left: 10, bottom: 10 })
                }
              }
              .width('100%')
              .borderRadius(8)
              .backgroundColor('#F5F5F5')
              .margin({ bottom: 8 })
            })
          }
          .width('90%')
          .margin({ top: 20 })

          // 评论过的中药
          Column() {
            Text('评论过的中药')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 10 })

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