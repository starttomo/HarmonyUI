import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { CommonConstants } from '../constants/CommonConstants';
import { VIDEO_LIST } from '../pages/VideoPage'; // 导入 VIDEO_LIST
import { BottomTabs } from '../components/BottomTabs';

// 20条真实中药知识问答
const KNOWLEDGE_QA = [
  { id: 1, question: '人参适合所有人吃吗？', answer: '人参不适合所有人，高血压患者或体质燥热者需谨慎食用，建议咨询医生。' },
  { id: 2, question: '枸杞可以每天吃吗？', answer: '适量食用枸杞有益，但过量可能导致上火，每天10-15克为宜。' },
  { id: 3, question: '当归煮汤有什么好处？', answer: '当归煮汤可补血活血，适合女性调理身体，但孕妇应避免使用。' },
  { id: 4, question: '黄芪的主要功效是什么？', answer: '黄芪有补气固表、利尿托毒、排脓生肌等功效，常用于体虚乏力。' },
  { id: 5, question: '板蓝根能预防感冒吗？', answer: '板蓝根有清热解毒作用，但不能作为日常预防感冒的药物长期服用。' },
  { id: 6, question: '金银花适合什么人群？', answer: '金银花适合咽喉肿痛、风热感冒者，体质虚寒者慎用。' },
  { id: 7, question: '藿香正气水能治什么？', answer: '藿香正气水主要用于暑湿感冒、恶心呕吐、腹泻等症状。' },
  { id: 8, question: '川贝和浙贝有区别吗？', answer: '川贝偏润肺止咳，浙贝偏清热化痰，二者功效略有不同。' },
  { id: 9, question: '孕妇能吃桂圆吗？', answer: '孕妇不宜多吃桂圆，容易引起上火或流产风险。' },
  { id: 10, question: '桑葚和枸杞能一起泡水喝吗？', answer: '桑葚和枸杞可以一起泡水，有补肝肾、明目作用。' },
  { id: 11, question: '牛黄解毒片能长期服用吗？', answer: '牛黄解毒片不宜长期服用，主要用于急性咽喉肿痛、口腔溃疡等。' },
  { id: 12, question: '胖大海泡水适合哪些人？', answer: '胖大海适合咽喉干哑、声音嘶哑者，脾胃虚寒者慎用。' },
  { id: 13, question: '三七粉的主要功效？', answer: '三七粉有活血化瘀、消肿止痛作用，常用于跌打损伤。' },
  { id: 14, question: '菊花茶适合什么体质？', answer: '菊花茶适合肝火旺、用眼过度者，体质虚寒者不宜多饮。' },
  { id: 15, question: '阿胶的补血效果好吗？', answer: '阿胶有良好的补血作用，适合血虚体质者，但不宜与感冒药同服。' },
  { id: 16, question: '甘草能和什么药同用？', answer: '甘草能调和诸药，但与甘遂、大戟、海藻等药物相反。' },
  { id: 17, question: '乌梅的功效有哪些？', answer: '乌梅有生津止渴、敛肺止咳、涩肠止泻等功效。' },
  { id: 18, question: '柴胡的主要用途？', answer: '柴胡用于感冒发热、胸胁胀痛、月经不调等。' },
  { id: 19, question: '决明子泡水喝的作用？', answer: '决明子有清肝明目、润肠通便作用，适合便秘者。' },
  { id: 20, question: '生姜红糖水适合什么情况？', answer: '生姜红糖水适合风寒感冒、经期腹痛者，热性体质慎用。' },
];

// 20条真实中药小知识
const HERBAL_KNOWLEDGE = [
  { id: 1, title: '人参的保存方法', content: '人参应密封保存于阴凉干燥处，避免受潮发霉。' },
  { id: 2, title: '枸杞的最佳食用时间', content: '枸杞宜早晨空腹或下午加餐时食用，利于吸收。' },
  { id: 3, title: '当归的搭配', content: '当归与黄芪、党参同用可增强补血效果。' },
  { id: 4, title: '黄芪泡水喝的注意事项', content: '黄芪泡水不宜过量，每次5-10克为宜。' },
  { id: 5, title: '金银花的泡法', content: '金银花可单独泡水或与菊花、枸杞搭配饮用。' },
  { id: 6, title: '胖大海的用量', content: '胖大海泡水每次1-2颗即可，过量易腹泻。' },
  { id: 7, title: '三七粉的服用方法', content: '三七粉可温水冲服或加入粥中，饭前服用效果更佳。' },
  { id: 8, title: '菊花茶的搭配', content: '菊花可与枸杞、决明子、金银花等搭配泡茶。' },
  { id: 9, title: '阿胶的食用禁忌', content: '阿胶不宜与萝卜、浓茶同食，感冒期间忌用。' },
  { id: 10, title: '桑葚的营养价值', content: '桑葚富含维生素C和铁，有补血养颜作用。' },
  { id: 11, title: '牛黄解毒片的注意事项', content: '牛黄解毒片不宜与酒同服，孕妇慎用。' },
  { id: 12, title: '决明子的保存', content: '决明子应密封避光保存，防止虫蛀。' },
  { id: 13, title: '乌梅的食用方法', content: '乌梅可泡水、煮粥或制成蜜饯食用。' },
  { id: 14, title: '柴胡的煎煮方法', content: '柴胡宜先煎20分钟后再加其它药材同煎。' },
  { id: 15, title: '生姜红糖水的禁忌', content: '热性体质、糖尿病患者不宜饮用生姜红糖水。' },
  { id: 16, title: '藿香正气水的保存', content: '藿香正气水应避光密封保存，开封后尽快用完。' },
  { id: 17, title: '板蓝根的服用建议', content: '板蓝根不宜长期服用，感冒初期可适量饮用。' },
  { id: 18, title: '桂圆的食用量', content: '桂圆每日食用不宜超过20克，过量易上火。' },
  { id: 19, title: '附子的炮制', content: '附子必须经过炮制去毒，切勿生用。' },
  { id: 20, title: '桑葚枸杞茶', content: '桑葚与枸杞搭配泡茶，有补肝肾、明目作用。' },
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
  @State qaList: any[] = [];
  @State knowledgeList: any[] = [];

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

    this.refreshQAKnowledge();
  }

  private refreshQAKnowledge() {
    // 随机抽取2条知识问答和2条中药小知识
    this.qaList = this.getRandomItems(KNOWLEDGE_QA, 2);
    this.knowledgeList = this.getRandomItems(HERBAL_KNOWLEDGE, 2);
  }

  private getRandomItems(arr: any[], n: number): any[] {
    const shuffled = arr.slice().sort(() => Math.random() - 0.5);
    return shuffled.slice(0, n);
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
            Column() {
              Row() {
                Text('知识问答')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .margin({ right: 10 })
                Button() {
                  Text('换一批').fontSize(12)
                }
                .width(60)
                .height(30)
                .backgroundColor('#007AFF')
                .onClick(() => this.refreshQAKnowledge())
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .padding(10)

              ForEach(this.qaList, (qa) => {
                Column() {
                  Text(qa.question)
                    .fontSize(14)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                    .margin({ left: 10, bottom: 5 })
                    .fontColor('#333333')
                  Text(qa.answer)
                    .fontSize(12)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                    .padding(10)
                    .backgroundColor('#E8E8E8')
                    .borderRadius(4)
                    .margin({ left: 10, right: 10, bottom: 10 })
                }
                .width('100%')
                .backgroundColor('#F5F5F5')
                .border({ width: 1, color: '#E0E0E0', radius: 12 })
                .margin({ bottom: 10 })
              }, qa => qa.id)
            }
            .width('100%')
            .padding(10)
            .margin({ bottom: 10 })

            // 中药知识区域
            Column() {
              Row() {
                Text('中药小知识')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .margin({ right: 10 })
                Button() {
                  Text('换一批').fontSize(12)
                }
                .width(60)
                .height(30)
                .backgroundColor('#007AFF')
                .onClick(() => this.refreshQAKnowledge())
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .padding(10)

              ForEach(this.knowledgeList, (item) => {
                Column() {
                  Text(item.title)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                    .margin({ left: 10, bottom: 5 })
                    .fontColor('#333333')
                  Text(item.content)
                    .fontSize(12)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                    .padding(10)
                    .backgroundColor('#E8E8E8')
                    .borderRadius(4)
                    .margin({ left: 10, right: 10, bottom: 10 })
                }
                .width('100%')
                .backgroundColor('#F5F5F5')
                .border({ width: 1, color: '#E0E0E0', radius: 12 })
                .margin({ bottom: 10 })
              }, item => item.id)
            }
            .width('100%')
            .padding(10)
            .margin({ bottom: 10 })
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