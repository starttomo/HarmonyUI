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
{ id: 4, image: CommonConstants.IMAGE_URL_1, title: '内容标题1', description: '这是内容1的描述', views: 100, liked: false, collected: false },
{ id: 5, image: CommonConstants.IMAGE_URL_2, title: '内容标题2', description: '这是内容2的描述', views: 150, liked: false, collected: false },
{ id: 6, image: CommonConstants.IMAGE_URL_3, title: '内容标题3', description: '这是内容3的描述', views: 200, liked: false, collected: false },
{ id: 7, image: CommonConstants.IMAGE_URL_4, title: '内容标题4', description: '这是内容4的描述', views: 250, liked: false, collected: false },
{ id: 4, image: CommonConstants.IMAGE_URL_1, title: '内容标题1', description: '这是内容1的描述', views: 100, liked: false, collected: false },
{ id: 5, image: CommonConstants.IMAGE_URL_2, title: '内容标题2', description: '这是内容2的描述', views: 150, liked: false, collected: false },
{ id: 6, image: CommonConstants.IMAGE_URL_3, title: '内容标题3', description: '这是内容3的描述', views: 200, liked: false, collected: false },
{ id: 7, image: CommonConstants.IMAGE_URL_4, title: '内容标题4', description: '这是内容4的描述', views: 250, liked: false, collected: false }
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
  @State isLoading: boolean = false; // 加载状态
  @State hasMore: boolean = true; // 是否还有更多数据

  // 生成新数据的方法
  private generateNewItems(): Array<any> {
    const newItems = [];
    const startId = this.contentList.length + 1;
    for (let i = 0; i < 4; i++) {
      newItems.push({
        id: startId + i,
        image: CommonConstants[`IMAGE_URL_${(startId + i) % 4 + 1}`],
        title: `新内容标题${startId + i}`,
        description: `这是新内容${startId + i}的描述`,
        views: Math.floor(Math.random() * 200) + 100,
        liked: false,
        collected: false
      });
    }
    return newItems;
  }

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

  // 加载更多数据
  private loadMoreData() {
    if (this.isLoading || !this.hasMore) return;

    this.isLoading = true;
    // 模拟异步加载数据
    setTimeout(() => {
      const newItems = this.generateNewItems();
      this.contentList = [...this.contentList, ...newItems];
      this.isLoading = false;

      // 模拟数据加载完毕的情况（例如加载到20条就停止）
      if (this.contentList.length >= 20) {
        this.hasMore = false;
      }
    }, 1000);
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
              .margin({ top: 8, bottom: 10 })
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

      // 可滑动列表
      Scroll() {
        Column() {
          ForEach(this.contentList, (item, index) => {
            // 列表项
            Row() {
              // 左侧图片
              Image(item.image)
                .width(100)
                .height(100)
                .objectFit(ImageFit.Cover)
                .borderRadius(8)
                .margin({ right: 10 })

              // 中间内容区域
              Column() {
                // 标题和描述区域
                Column() {
                  Text(item.title)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .textAlign(TextAlign.Start)
                    .width('100%')
                    .margin({ bottom: 4 })

                  Text(item.description)
                    .fontSize(12)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(2)
                    .textAlign(TextAlign.Start)
                    .width('100%')
                }
                .width('100%')
                .height(60)
                .justifyContent(FlexAlign.Start)

                // 底部操作区域
                Row() {
                  // 点赞区域
                  Row() {
                    Button(item.liked ? '取消' : '点赞', { type: ButtonType.Capsule })
                      .fontSize(10)
                      .height(20)
                      .width(40)
                      .backgroundColor(item.liked ? '#FF9999' : '#007AFF')
                      .onClick(() => this.toggleLike(item))

                    Text(`点赞量`)
                      .fontSize(10)
                      .margin({ left: 4 })
                  }
                  .margin({ right: 8 })

                  // 收藏区域
                  Row() {
                    Button(item.collected ? '取消' : '收藏', { type: ButtonType.Capsule })
                      .fontSize(10)
                      .height(20)
                      .width(40)
                      .backgroundColor(item.collected ? '#FF9999' : '#007AFF')
                      .onClick(() => this.toggleCollect(item))

                    Text(`收藏量`)
                      .fontSize(10)
                      .margin({ left: 4 })
                  }
                }
                .width('100%')
                .height(30)
                .justifyContent(FlexAlign.Start)
                .alignItems(VerticalAlign.Bottom)
              }
              .flexGrow(1)
              .height('100%')
              .width('50%')
              .justifyContent(FlexAlign.SpaceBetween)
              .margin({ right: 10 })

              // 右侧学习按钮
              Button() {
                Text("学\n习\n一\n下")
              }
              .width(30)
              .height(100)
              .fontSize(12)
              .backgroundColor('#FF9999')
              .borderRadius(8)
              .onClick(() => this.navigateToDetail(item.id))
            }
            .width('100%')
            .height(120)
            .padding(10)
            .backgroundColor('#F5F5F5')
            .borderRadius(12)
          })

          // 加载更多提示
          if (this.isLoading) {
            Row() {
              Progress({ value: 50 })
                .width(20)
                .height(20)
              Text('加载中...')
                .margin({ left: 8 })
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .margin({ top: 10, bottom: 20 })
          }

          if (!this.hasMore && !this.isLoading) {
            Text('没有更多内容了')
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ top: 10, bottom: 20 })
              .fontColor('#999999')
          }
        }
      }
      .onScrollEdge((edge: number) => {
        if (edge === 1) {
          this.loadMoreData();
        }
      })
      .layoutWeight(1)
      .flexGrow(1)
      .width('100%')

      // 底部导航栏
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
        }.tabBar({ icon: $r('app.media.home'), text: '首页' })

        TabContent() {
        }.tabBar({ icon: $r('app.media.video'), text: '视频' })

        TabContent() {
        }.tabBar({ icon: $r('app.media.learn'), text: '学习' })

        TabContent() {
        }.tabBar({ icon: $r('app.media.user'), text: '个人' })
      }
      .barMode(BarMode.Fixed)
      .width('100%')
      .height(60)
      .onChange((index: number) => {
        if (index !== 0) {
          router.pushUrl({ url: NAV_ITEMS[index].route });
        }
        this.selectedIndex = index;
      })
    }
    .width('100%')
    .height('100%')
  }
  }