import router from '@ohos.router';
import prompt from '@system.prompt';
import { CommonConstants } from '../constants/CommonConstants';
import { BackendService } from '../services/BackendService';
import media from '@ohos.multimedia.media';

// 模拟数据
const CONTENT_LIST = [
  { id: 1, image: CommonConstants.IMAGE_URL_1, title: '内容标题1', description: '这是内容1的描述', views: 100, liked: false, collected: false },
  { id: 2, image: CommonConstants.IMAGE_URL_2, title: '内容标题2', description: '这是内容2的描述', views: 150, liked: false, collected: false },
  { id: 3, image: CommonConstants.IMAGE_URL_3, title: '内容标题3', description: '这是内容3的描述', views: 200, liked: false, collected: false },
  { id: 4, image: CommonConstants.IMAGE_URL_4, title: '内容标题4', description: '这是内容4的描述', views: 250, liked: false, collected: false }
];

// 底部导航栏数据
const NAV_ITEMS = [
  { name: '首页', icon: CommonConstants.HOME_ICON, route: 'pages/HomePage' },
  { name: '视频', icon: CommonConstants.VIDEO_ICON, route: 'pages/VideoPage' },
  { name: '每日一学', icon: CommonConstants.STUDY_ICON, route: 'pages/StudyPage' },
  { name: '我的', icon: CommonConstants.PROFILE_ICON, route: 'pages/ProfilePage' }
];

@Entry
@Component
struct HomePage {
  @State selectedIndex: number = 0; // 当前选中的导航项
  @State contentList: Array<any> = CONTENT_LIST; // 内容列表

  // 点赞操作
  private async toggleLike(item: any) {
    item.liked = !item.liked;
    try {
      await BackendService.toggleLike(item.id, item.liked);
      prompt.showToast({ message: item.liked ? '点赞成功' : '取消点赞' });
    } catch (error) {
      prompt.showToast({ message: '点赞失败，请重试' });
    }
  }

  // 收藏操作
  private async toggleCollect(item: any) {
    item.collected = !item.collected;
    try {
      await BackendService.toggleCollect(item.id, item.collected);
      prompt.showToast({ message: item.collected ? '收藏成功' : '取消收藏' });
    } catch (error) {
      prompt.showToast({ message: '收藏失败，请重试' });
    }
  }

  // 跳转到详情页
  private navigateToDetail(id: number) {
    router.pushUrl({
      url: 'pages/DetailPage',
      params: { contentId: id }
    });
  }

  build() {
    Column() {
      // 顶部滚动部件
      Swiper() {
        ForEach(CommonConstants.BANNER_IMAGES, (banner, index) => {
          Column() {
            Image(banner.url)
              .width('100%')
              .height(200)
              .objectFit(ImageFit.Cover)
            Text(banner.description)
              .fontSize(16)
              .margin({ top: 8 })
              .textAlign(TextAlign.Center)
          }
          .width('100%')
        }, item => item.url)
      }
      .width('100%')
      .height(240)
      .indicator(true)
      .loop(true)
      .autoPlay(true)
      .interval(2000)

      // 内容列表
      List({ space: 10 }) {
        ForEach(this.contentList, (item) => {
          ListItem() {
            Row() {
              Image(item.image)
                .width(100)
                .height(100)
                .objectFit(ImageFit.Cover)
                .borderRadius(8)
                .margin({ right: 10 })
              Column() {
                Text(item.title)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .margin({ bottom: 5 })
                Text(item.description)
                  .fontSize(14)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(2)
                Row() {
                  Text(`浏览量: ${item.views}`)
                    .fontSize(12)
                    .margin({ right: 10 })
                  Button(item.liked ? '取消点赞' : '点赞', { type: ButtonType.Capsule })
                    .backgroundColor(item.liked ? '#FF9999' : '#007AFF')
                    .onClick(() => this.toggleLike(item))
                    .margin({ right: 5 })
                  Button(item.collected ? '取消收藏' : '收藏', { type: ButtonType.Capsule })
                    .backgroundColor(item.collected ? '#FF9999' : '#007AFF')
                    .onClick(() => this.toggleCollect(item))
                }
                .margin({ top: 5 })
              }
              .flexGrow(1)

              Button('学习一下', { type: ButtonType.Capsule })
                .backgroundColor('#007AFF')
                .onClick(() => this.navigateToDetail(item.id))
                .margin({ right:5 })
            }
            .padding(10)
            .width('100%')
            .backgroundColor('#F5F5F5')
            .borderRadius(12)
          }
        }, item => item.id)
      }
      .width('100%')
      .padding({ left: 10, right: 10 })

      // 底部导航栏（正确实现）
      Tabs({ barPosition: BarPosition.End }) {
        // 首页Tab
        TabContent() {
          // 首页内容已在主Column中实现，这里可以留空或放占位
        }.tabBar({
          icon: $r('app.media.home'),
          text: '首页'
        })

        // 视频Tab
        TabContent() {
          // 视频页内容
        }.tabBar({
          icon: $r('app.media.video'),
          text: '视频'
        })

        // 每日一学Tab
        TabContent() {
          // 学习页内容
        }.tabBar({
          icon: $r('app.media.learn'),
          text: '学习'
        })
        // 我的Tab
        TabContent() {
          // 个人中心内容
        }.tabBar({
          icon: $r('app.media.user'),
          text: '个人'
        })
      }
      .barMode(BarMode.Fixed)
      .vertical(false)
      .width('100%')
      .height(60)
      .backgroundColor('#FFFFFF')
      .onChange((index: number) => {
        if (index !== 0) {
          router.pushUrl({ url: NAV_ITEMS[index].route });
        }
        this.selectedIndex = index;
      })
    }
  }
}