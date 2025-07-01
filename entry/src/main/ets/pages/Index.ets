import router from '@ohos.router';
import prompt from '@system.prompt';
import { CommonConstants } from '../constants/CommonConstants';
import { BackendService } from '../services/BackendService';
import media from '@ohos.multimedia.media';
import { BottomTabs } from '../components/BottomTabs';

// 模拟数据，新增类别字段
const CONTENT_LIST = [
  { id: 1, image: CommonConstants.IMAGE_URL_1, title: '人参', description: '补气养血', views: 100, liked: false, collected: false, category: '根茎类' },
  { id: 2, image: CommonConstants.IMAGE_URL_2, title: '枸杞', description: '滋补肝肾', views: 150, liked: false, collected: false, category: '果实类' },
  { id: 3, image: CommonConstants.IMAGE_URL_3, title: '当归', description: '补血活血', views: 200, liked: false, collected: false, category: '根茎类' },
  { id: 4, image: CommonConstants.IMAGE_URL_1, title: '黄芪', description: '益气固表', views: 100, liked: false, collected: false, category: '根茎类' },
  { id: 5, image: CommonConstants.IMAGE_URL_2, title: '山楂', description: '健脾消食', views: 150, liked: false, collected: false, category: '果实类' },
  { id: 6, image: CommonConstants.IMAGE_URL_3, title: '甘草', description: '调和诸药', views: 200, liked: false, collected: false, category: '根茎类' },
  { id: 7, image: CommonConstants.IMAGE_URL_4, title: '菊花', description: '清热解毒', views: 250, liked: false, collected: false, category: '花类' },
];

// 类别数据
const CATEGORIES = [
  { name: '全部', value: 'all' },
  { name: '根茎类', value: '根茎类' },
  { name: '果实类', value: '果实类' },
  { name: '花类', value: '花类' },
  { name: '叶类', value: '叶类' },
];

// 底部导航栏数据
const NAV_ITEMS = [
  { name: '首页', icon: CommonConstants.HOME_ICON, route: 'pages/HomePage' },
  { name: '视频', icon: CommonConstants.VIDEO_ICON, route: 'pages/VideoPage' },
  { name: '每日一学', icon: CommonConstants.STUDY_ICON, route: 'pages/StudyPage' },
  { name: '我的', icon: CommonConstants.PROFILE_ICON, route: 'pages/ProfilePage' },
];

@Entry
@Component
struct HomePage {
  @State selectedIndex: number = 0; // 当前选中的导航项
  @State contentList: Array<any> = CONTENT_LIST; // 内容列表
  @State filteredList: Array<any> = CONTENT_LIST; // 过滤后的列表
  @State isLoading: boolean = false; // 加载状态
  @State hasMore: boolean = true; // 是否还有更多数据
  @State searchText: string = ''; // 搜索文本
  @State selectedCategory: string = 'all'; // 当前选中的类别

  // 生成新数据的方法
  private generateNewItems(): Array<any> {
    const newItems = [];
    const startId = this.contentList.length + 1;
    const categories = ['根茎类', '果实类', '花类', '叶类'];
    for (let i = 0; i < 4; i++) {
      newItems.push({
        id: startId + i,
        image: CommonConstants[`IMAGE_URL_${(startId + i) % 4 + 1}`],
        title: `新中药${startId + i}`,
        description: `这是新中药${startId + i}的描述`,
        views: Math.floor(Math.random() * 200) + 100,
        liked: false,
        collected: false,
        category: categories[Math.floor(Math.random() * categories.length)],
      });
    }
    return newItems;
  }

  // 搜索过滤
  private filterContent() {
    let result = this.contentList;
    // 按名称搜索
    if (this.searchText) {
      result = result.filter(item => item.title.includes(this.searchText));
    }
    // 按类别过滤
    if (this.selectedCategory !== 'all') {
      result = result.filter(item => item.category === this.selectedCategory);
    }
    this.filteredList = result;
  }

  // 搜索输入变化
  private onSearchChange(value: string) {
    this.searchText = value;
    this.filterContent();
  }

  // 类别选择变化
  private onCategoryChange(value: string) {
    this.selectedCategory = value;
    this.filterContent();
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
      params: { contentId: id },
    });
  }

  // 加载更多数据
  private loadMoreData() {
    if (this.isLoading || !this.hasMore) return;

    this.isLoading = true;
    setTimeout(() => {
      const newItems = this.generateNewItems();
      this.contentList = [...this.contentList, ...newItems];
      this.filterContent(); // 更新过滤后的列表
      this.isLoading = false;

      if (this.contentList.length >= 20) {
        this.hasMore = false;
      }
    }, 1000);
  }

  build() {
    Column() {
      // 搜索栏
      // 搜索栏
      Row() {
        TextInput({ placeholder: '搜索中药材名称', text: this.searchText })
          .width('70%')
          .height(40)
          .margin({ right: 10 })
          .onChange(value => this.onSearchChange(value))
        Button() {
          Text('搜索')
            .fontSize(14)
        }
        .width('20%')
        .height(40)
        .onClick(() => this.filterContent())
      }
      .width('100%')
      .padding(10)
      .backgroundColor('#F5F5F5')

      // 类别选择器
      Tabs({ barPosition: BarPosition.Start, index: this.selectedCategory === 'all' ? 0 : CATEGORIES.findIndex(cat => cat.value === this.selectedCategory) }) {
        ForEach(CATEGORIES, (cat, index) => {
          TabContent() {
            Text(cat.name)
              .fontSize(16)
              .padding(10)
          }
          .tabBar(cat.name)
        }, item => item.value)
      }
      .width('100%')
      .height(40)
      .onChange((index: number) => {
        this.onCategoryChange(CATEGORIES[index].value);
      })
      .barWidth('100%')
      .padding({ left: 10, right: 10, bottom: 10 })

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
          if (this.filteredList.length === 0) {
            Text('没有找到匹配的内容')
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ top: 20 })
              .fontColor('#999999')
          } else {
            ForEach(this.filteredList, (item, index) => {
              Row() {
                Image(item.image)
                  .width(100)
                  .height(100)
                  .objectFit(ImageFit.Cover)
                  .borderRadius(8)
                  .margin({ right: 10 })

                Column() {
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
                    Text(`类别: ${item.category}`)
                      .fontSize(10)
                      .fontColor('#666666')
                      .margin({ top: 4 })
                  }
                  .width('100%')
                  .height(60)
                  .justifyContent(FlexAlign.Start)

                  Row() {
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
                .width(70)
                .height('100%')
                .justifyContent(FlexAlign.SpaceBetween)
                .margin({ right: 10 })

                Button() {
                  Text("了\n解\n一\n下")
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
            }, item => item.id.toString())
          }

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
      BottomTabs()
    }
    .width('100%')
    .height('100%')
  }
}