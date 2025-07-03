import router from '@ohos.router';
import prompt from '@system.prompt';
import { CommonConstants } from '../constants/CommonConstants';
import { BackendService } from '../services/BackendService';
import media from '@ohos.multimedia.media';
import { BottomTabs } from '../components/BottomTabs';
import preferences from '@ohos.data.preferences';

// 类别数据
const CATEGORIES = [
  { name: '全部', value: 'all' },
  { name: '解表药', value: '解表药' },
  { name: '清热药', value: '清热药' },
  { name: '祛风湿药', value: '祛风湿药' },
  { name: '补虚药', value: '补虚药' },
];

@Entry
@Component
struct HomePage {
  @State selectedIndex: number = 0;
  @State contentList: Array<any> = [];
  @State filteredList: Array<any> = [];
  @State isLoading: boolean = false;
  @State hasMore: boolean = true;
  @State searchText: string = '';
  @State selectedCategory: string = 'all';
  @State userId: number = 0;

  aboutToAppear() {
    this.initPage();
    console.log('HomePage called');
  }

  onPageShow() {
    this.initPage();
  }

  private async initPage() {
    await this.loadUserId();
    await this.fetchData();
  }

  private async fetchData() {
    this.isLoading = true;
    try {
      console.log(`正在请求分类: ${this.selectedCategory}`); // 打印当前请求的分类
      const data = await BackendService.fetchHerbList(this.searchText, this.selectedCategory, this.userId);
      this.contentList = data;
      this.filteredList = data;
      this.hasMore = data.length >= 100;
    } catch (e) {
      prompt.showToast({ message: '数据加载失败' });
    }
    this.isLoading = false;
  }

  private onSearchChange(value: string) {
    this.searchText = value;
    this.fetchData();
  }

  private onCategoryChange(value: string) {
    this.selectedCategory = value;
    this.fetchData();
  }

  private async loadUserId() {
    try {
      const context = getContext(this);
      const pref = await preferences.getPreferences(context, 'user_token');
      const userIdValue = await pref.get('user_id', 0);
      this.userId = Number(userIdValue);
    } catch (e) {
      this.userId = 0;
    }
  }

  private async toggleLike(item: any) {
    if (!this.userId) {
      prompt.showToast({ message: '请先登录' });
      return;
    }
    try {
      await BackendService.toggleLike(item.herb_id, !item.liked, this.userId);
      item.liked = !item.liked;
      prompt.showToast({ message: item.liked ? '点赞成功' : '取消点赞' });
      this.fetchData(); // 刷新数据，确保点赞量同步
    } catch (e) {
      prompt.showToast({ message: '操作失败' });
    }
  }

  private async toggleCollect(item: any) {
    if (!this.userId) {
      prompt.showToast({ message: '请先登录' });
      return;
    }
    try {
      await BackendService.toggleCollect(item.herb_id, !item.collected, this.userId);
      item.collected = !item.collected;
      prompt.showToast({ message: item.collected ? '收藏成功' : '取消收藏' });
      this.fetchData(); // 刷新数据，确保收藏量同步
    } catch (e) {
      prompt.showToast({ message: '操作失败' });
    }
  }

  private async navigateToDetail(id: number) {
    if (this.userId) {
      try {
        await BackendService.addView(id, this.userId);
        this.fetchData(); // 浏览量+1后刷新数据
      } catch (e) {
        // 忽略错误
      }
    }
    router.pushUrl({
      url: 'pages/DetailPage',
      params: { contentId: id },
    });
  }

  build() {

    Column() {
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
        .onClick(() => this.fetchData())
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
                Image(item.image_url)
                  .width(100)
                  .height(100)
                  .objectFit(ImageFit.Cover)
                  .borderRadius(8)
                  .margin({ right: 10 })

                Column() {
                  Column() {
                    Text(item.herb_name)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .textAlign(TextAlign.Start)
                      .width('100%')
                      .margin({ bottom: 4 })
                    Text(item.indications || '')
                      .fontSize(12)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .maxLines(2)
                      .textAlign(TextAlign.Start)
                      .width('100%')
                    Text(`类别: ${item.category_name || ''}`)
                      .fontSize(10)
                      .fontColor('#666666')
                      .margin({ top: 4 })
                  }
                  .width('100%')
                  .height(60)
                  .justifyContent(FlexAlign.Start)

                  Row() {
                    Button({ type: ButtonType.Capsule }) {
                      Text(item.liked ? '取消点赞' : '点赞')
                        .fontSize(14)
                        .fontWeight(FontWeight.Medium)
                    }
                    .height(28)
                    .width(60)
                    .backgroundColor(item.liked ? '#FF9999' : '#007AFF')
                    .onClick(() => this.toggleLike(item))

                    Button({ type: ButtonType.Capsule }) {
                      Text(item.collected ? '取消收藏' : '收藏')
                        .fontSize(14)
                        .fontWeight(FontWeight.Medium)
                    }
                    .height(28)
                    .width(60)
                    .backgroundColor(item.collected ? '#FF9999' : '#007AFF')
                    .onClick(() => this.toggleCollect(item))
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
                .onClick(() => this.navigateToDetail(item.herb_id))
              }
              .width('100%')
              .height(120)
              .padding(10)
              .backgroundColor('#F5F5F5')
              .borderRadius(12)
            }, item => item.herb_id.toString())
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
          this.fetchData();
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