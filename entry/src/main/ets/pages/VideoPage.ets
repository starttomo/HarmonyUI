import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { CommonConstants } from '../constants/CommonConstants';
import { BottomTabs } from '../components/BottomTabs';

// 模拟视频数据
export const VIDEO_LIST = [
  {
    id: 1,
    thumbnail: CommonConstants.IMAGE_URL_1,
    videoUrl: $rawfile('videox.mp4'), // 使用本地视频文件
    title: '人参药效视频',
    description: '了解人参的药效与使用方法',
    likes: 120,
    comments: ['很好，学到了很多！', '人参补气效果显著'],
    liked: false,
  },
  {
    id: 2,
    thumbnail: CommonConstants.IMAGE_URL_2,
    videoUrl: 'resources://rawfile/videox.mp4',
    title: '枸杞养生视频',
    description: '枸杞的养生功效与食用技巧',
    likes: 80,
    comments: ['内容很实用！'],
    liked: false,
  },
  {
    id: 3,
    thumbnail: CommonConstants.IMAGE_URL_3,
    videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    title: '当归补血视频',
    description: '当归的补血作用及注意事项',
    likes: 150,
    comments: [],
    liked: false,
  },
];

@Entry
@Component
struct VideoPage {
  @State currentVideoIndex: number = 0; // 当前滑动器视频索引
  @State videoList: Array<any> = VIDEO_LIST; // 视频列表
  @State commentVisibility: { [key: number]: boolean } = {}; // 控制评论区域显示

  // 播放视频
  private playVideo(videoUrl: string) {
    console.info('尝试播放视频:', videoUrl);
    router.pushUrl({
      url: 'pages/VideoPlayerPage',
      params: { videoUrl: videoUrl }
    }).catch((err) => {
      console.error('路由跳转失败:', JSON.stringify(err));
      promptAction.showToast({
        message: '无法打开播放器: ' + JSON.stringify(err),
        duration: 3000
      });
    });
  }

  // 切换点赞状态
  private toggleLike(item: any) {
    // 修改点赞状态和点赞数
    item.likes = item.liked ? item.likes - 1 : item.likes + 1;
    item.liked = !item.liked;

    // 深拷贝 videoList 以触发 UI 更新
    this.videoList = [...this.videoList];

    // 显示提示信息
    promptAction.showToast({
      message: item.liked ? '点赞成功' : '取消点赞',
      duration: 2000
    });
  }

  // 打开评论输入页面
  private openCommentDialog(itemId: number) {
    router.pushUrl({
      url: 'pages/CommentInputPage',
      params: { itemId },
    }).catch((err) => {
      console.error('评论页面跳转失败:', JSON.stringify(err));
      promptAction.showToast({
        message: '无法打开评论页面',
        duration: 2000
      });
    });
  }

  // 切换评论区域显示
  private toggleCommentVisibility(itemId: number) {
    this.commentVisibility[itemId] = !this.commentVisibility[itemId];
  }

  build() {
    Column() {
      // 标题
      Text('中草药视频学习')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ left: 10, top: 10, bottom: 10 })

      // 水平视频滑动器
      Swiper() {
        ForEach(this.videoList, (item) => {
          Column() {
            Image(item.thumbnail)
              .width('100%')
              .height(150)
              .objectFit(ImageFit.Cover)
              .borderRadius(8)
              .onClick(() => this.playVideo(item.videoUrl))
          }
          .width('100%')
        }, item => item.id.toString())
      }
      .width('100%')
      .height(150)
      .indicator(true)
      .loop(true)
      .autoPlay(false)
      .onChange((index: number) => {
        this.currentVideoIndex = index;
      })

      // 视频描述
      Text(this.videoList[this.currentVideoIndex]?.description || '请选择一个视频')
        .fontSize(14)
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ top: 10, bottom: 10 })
        .fontColor('#666666')

      // 垂直视频列表
      Scroll() {
        Column() {
          ForEach(this.videoList, (item) => {
            Column() {
              // 视频项
              Row() {
                // 缩略图
                Image(item.thumbnail)
                  .width(100)
                  .height(100)
                  .objectFit(ImageFit.Cover)
                  .borderRadius(8)
                  .margin({ right: 10 })
                  .onClick(() => this.playVideo(item.videoUrl))

                // 内容
                Column() {
                  Text(item.title)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                    .margin({ bottom: 8 })

                  Column() {
                    Button() {
                      Text(item.liked ? '取消' : '点赞')
                        .fontSize(12) // 修复 Gavin 错误，设置为 12
                    }
                    .width(60)
                    .height(30)
                    .backgroundColor(item.liked ? '#FF9999' : '#007AFF')
                    .margin({ bottom: 8 })
                    .onClick(() => this.toggleLike(item))

                    Button() {
                      Text('评论')
                        .fontSize(12)
                    }
                    .width(60)
                    .height(30)
                    .backgroundColor('#007AFF')
                    .onClick(() => this.openCommentDialog(item.id))
                  }
                  .width('60%')
                }
                .width('50%')
                .height(100)
                .justifyContent(FlexAlign.Start)

                // 点赞数显示
                Text(`${item.likes} 点赞`)
                  .fontSize(12)
                  .margin({ top: 8 })
              }
              .width('100%')
              .padding(10)
              .backgroundColor('#F5F5F5')
              .borderRadius(12)

              // 评论区域
              Column() {
                Row() {
                  Text(this.commentVisibility[item.id] ? '隐藏评论' : '显示评论')
                    .fontSize(12)
                    .padding(5)
                    .onClick(() => this.toggleCommentVisibility(item.id))
                }
                .width('100%')
                .backgroundColor('#E0E0E0')
                .borderRadius(4)

                if (this.commentVisibility[item.id]) {
                  Scroll() {
                    Column() {
                      if (item.comments.length === 0) {
                        Text('暂无评论')
                          .fontSize(12)
                          .fontColor('#999999')
                          .width('100%')
                          .textAlign(TextAlign.Center)
                          .padding(5)
                      } else {
                        ForEach(item.comments, (comment) => {
                          Text(comment)
                            .fontSize(12)
                            .width('100%')
                            .textAlign(TextAlign.Start)
                            .padding(5)
                            .backgroundColor('#E8E8E8')
                            .borderRadius(4)
                            .margin({ bottom: 4 })
                        }, (comment: string) => comment)
                      }
                    }
                    .width('100%')
                  }
                  .height(100)
                  .clip(true)
                  .margin({ top: 5 })
                }
              }
              .width('100%')
              .padding({ left: 10, right: 10, bottom: 10 })
            }
            .width('100%')
            .margin({ bottom: 10 })
          }, item => item.id.toString())
        }
        .width('100%')
      }
      .layoutWeight(1)
      .flexGrow(1)
      .width('100%')

      // 底部导航
      BottomTabs();
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}