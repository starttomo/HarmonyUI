import router from '@ohos.router';
import prompt from '@system.prompt';
import { CommonConstants } from '../constants/CommonConstants';
import { BackendService } from '../services/BackendService';
import media from '@ohos.multimedia.media';
import { BottomTabs } from '../components/BottomTabs';

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
  @State selectedIndex: number = 0;
  @State contentList: Array<any> = [];
  @State filteredList: Array<any> = [];
  @State isLoading: boolean = false;
  @State hasMore: boolean = true;
  @State searchText: string = '';
  @State selectedCategory: string = 'all';

  aboutToAppear() {
    this.fetchData();
  }

  private async fetchData() {
    this.isLoading = true;
    try {
      const data = await BackendService.fetchHerbList(this.searchText, this.selectedCategory);
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

  private navigateToDetail(id: number) {
    router.pushUrl({
      url: 'pages/DetailPage',
      params: { contentId: id },
    });
  }

  private toggleLike(item: any) {
    prompt.showToast({ message: '点赞功能暂未实现' });
  }

  private toggleCollect(item: any) {
    prompt.showToast({ message: '收藏功能暂未实现' });
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
                Image(item.image_url || CommonConstants.IMAGE_URL_1)
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