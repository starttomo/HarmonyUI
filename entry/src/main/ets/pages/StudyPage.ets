import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { CommonConstants } from '../constants/CommonConstants';
import { VIDEO_LIST } from '../pages/VideoPage'; // 导入 VIDEO_LIST
import { BottomTabs } from '../components/BottomTabs';

// 知识问答数据
const KNOWLEDGE_QA = [
  {
    id: 1,
    question: '人参适合所有人吃吗？',
    answer: '人参不适合所有人，高血压患者或体质燥热者需谨慎食用，建议咨询医生。'
  },
  {
    id: 2,
    question: '枸杞可以每天吃吗？',
    answer: '适量食用枸杞有益，但过量可能导致上火，每天10-15克为宜。'
  },
  {
    id: 3,
    question: '当归煮汤有什么好处？',
    answer: '当归煮汤可补血活血，适合女性调理身体，但孕妇应避免使用。'
  }
];

// 中药知识数据
const HERBAL_KNOWLEDGE = [
  {
    id: 1,
    title: '当归的妙用',
    content: '当归不仅补血，还能助眠，加入鸡汤中味道更佳！'
  },
  {
    id: 2,
    title: '附子的毒性',
    content: '附子有毒，需炮制后使用，擅自服用可能导致中毒。'
  },
  {
    id: 3,
    title: '枸杞的小妙招',
    content: '枸杞泡茶可护眼，搭配菊花效果更佳，适合长期用眼者。'
  }
];

@Entry
@Component
struct DailyLearningPage {
  @State selectedVideo: any = null; // 存储随机选择的视频
  @State selectedQA: any = null; // 存储随机选择的问答
  @State selectedKnowledge: any = null; // 存储随机选择的中药知识
  @State commentVisibility: boolean = false; // 控制评论区域显示
  @State qaVisibility: boolean = false; // 控制问答答案显示
  @State animationStart: boolean = false; // 控制动画开始

  // 页面加载时随机选择内容
  aboutToAppear() {
    // 随机选择视频、问答和知识
    const randomVideoIndex = Math.floor(Math.random() * VIDEO_LIST.length);
    const randomQAIndex = Math.floor(Math.random() * KNOWLEDGE_QA.length);
    const randomKnowledgeIndex = Math.floor(Math.random() * HERBAL_KNOWLEDGE.length);
    this.selectedVideo = VIDEO_LIST[randomVideoIndex];
    this.selectedQA = KNOWLEDGE_QA[randomQAIndex];
    this.selectedKnowledge = HERBAL_KNOWLEDGE[randomKnowledgeIndex];

    // 延迟触发动画
    setTimeout(() => {
      this.animationStart = true;
    }, 100);
  }

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
  private toggleLike() {
    if (this.selectedVideo) {
      this.selectedVideo.likes = this.selectedVideo.liked ? this.selectedVideo.likes - 1 : this.selectedVideo.likes + 1;
      this.selectedVideo.liked = !this.selectedVideo.liked;
      promptAction.showToast({
        message: this.selectedVideo.liked ? '点赞成功' : '取消点赞',
        duration: 2000
      });
    }
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
  private toggleCommentVisibility() {
    this.commentVisibility = !this.commentVisibility;
  }

  // 切换问答答案显示
  private toggleQAVisibility() {
    this.qaVisibility = !this.qaVisibility;
  }

  build() {
    Column() {
      // 标题
      Text('每日一学')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ left: 10, top: 10, bottom: 10 })

      Scroll() {
        Column() {
          if (this.selectedVideo) {
            // 视频区域
            Column() {
              Row() {
                // 缩略图
                Image(this.selectedVideo.thumbnail)
                  .width(100)
                  .height(100)
                  .objectFit(ImageFit.Cover)
                  .borderRadius(8)
                  .margin({ right: 10 })
                  .onClick(() => this.playVideo(this.selectedVideo.videoUrl))
                  // .animation({
                  //   opacity: this.animationStart ? 1 : 0,
                  //   duration: 500,
                  //   curve: Curve.EaseInOut
                  // })

                // 视频内容
                Column() {
                  Text(this.selectedVideo.title)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                    .margin({ bottom: 8 })

                  Column() {
                    Button() {
                      Text(this.selectedVideo.liked ? '取消' : '点赞')
                        .fontSize(12)
                    }
                    .width(60)
                    .height(30)
                    .backgroundColor(this.selectedVideo.liked ? '#FF9999' : '#007AFF')
                    .margin({ bottom: 8 })
                    .onClick(() => this.toggleLike())

                    Button() {
                      Text('评论')
                        .fontSize(12)
                    }
                    .width(60)
                    .height(30)
                    .backgroundColor('#007AFF')
                    .onClick(() => this.openCommentDialog(this.selectedVideo.id))
                  }
                  .width('60%')
                }
                .width('50%')
                .height(100)
                .justifyContent(FlexAlign.Start)

                Text(`${this.selectedVideo.likes} 点赞`)
                  .fontSize(12)
                  .margin({ top: 8 })
              }
              .width('100%')
              .padding(10)
              .backgroundColor('#F5F5F5')
              .borderRadius(12)
              // .animation({
              //   opacity: this.animationStart ? 1 : 0,
              //   duration: 500,
              //   curve: Curve.EaseInOut
              // })

              // 视频描述
              Text(this.selectedVideo.description)
                .fontSize(14)
                .width('100%')
                .textAlign(TextAlign.Start)
                .margin({ top: 10, bottom: 10, left: 10 })
                .fontColor('#666666')

              // 评论区域

              Column() {
                Row() {
                  Text(this.commentVisibility ? '隐藏评论' : '显示评论')
                    .fontSize(12)
                    .padding(5)
                    .onClick(() => this.toggleCommentVisibility())
                }
                .width('100%')
                .backgroundColor('#E0E0E0')
                .borderRadius(4)

                if (this.commentVisibility) {
                  Scroll() {
                    Column() {
                      if (this.selectedVideo.comments.length === 0) {
                        Text('暂无评论')
                          .fontSize(12)
                          .fontColor('#999999')
                          .width('100%')
                          .textAlign(TextAlign.Center)
                          .padding(5)
                      } else {
                        ForEach(this.selectedVideo.comments, (comment: string) => {
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

            // 知识问答区域
            if (this.selectedQA) {
              Column() {
                Row() {
                  Text('知识问答')
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .margin({ right: 10 })
                  Text(this.qaVisibility ? '隐藏答案' : '显示答案')
                    .fontSize(12)
                    .padding(5)
                    .backgroundColor('#E0E0E0')
                    .borderRadius(4)
                    .onClick(() => this.toggleQAVisibility())
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
                .padding(10)

                Text(this.selectedQA.question)
                  .fontSize(14)
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .margin({ left: 10, bottom: 5 })
                  .fontColor('#333333')

                if (this.qaVisibility) {
                  Text(this.selectedQA.answer)
                    .fontSize(12)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                    .padding(10)
                    .backgroundColor('#E8E8E8')
                    .borderRadius(4)
                    .margin({ left: 10, right: 10 })
                }
              }
              .width('100%')
              .padding(10)
              .backgroundColor('#F5F5F5')
              .border({ width: 1, color: '#E0E0E0', radius: 12 })
              .margin({ bottom: 10 })
              // .animation({
              //   opacity: this.animationStart ? 1 : 0,
              //   duration: 500,
              //   curve: Curve.EaseInOut
              // })
            }

            // 中药知识区域
            if (this.selectedKnowledge) {
              Column() {
                Text('中药小知识')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .margin({ left: 10, bottom: 5 })

                Text(this.selectedKnowledge.title)
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .margin({ left: 10, bottom: 5 })
                  .fontColor('#333333')

                Text(this.selectedKnowledge.content)
                  .fontSize(12)
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .padding(10)
                  .backgroundColor('#E8E8E8')
                  .borderRadius(4)
                  .margin({ left: 10, right: 10 })
              }
              .width('100%')
              .padding(10)
              .backgroundColor('#F5F5F5')
              .border({ width: 1, color: '#E0E0E0', radius: 12 })
              .margin({ bottom: 10 })
              // .animation({
              //   opacity: this.animationStart ? 1 : 0,
              //   duration: 500,
              //   curve: Curve.EaseInOut
              // })
            }
          } else {
            Text('加载中...')
              .fontSize(14)
              .fontColor('#666666')
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ top: 20 })
          }
        }
        .width('100%')
      }
      .layoutWeight(1)
      .flexGrow(1)

      // 底部导航
      BottomTabs();
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}