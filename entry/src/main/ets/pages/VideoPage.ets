import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { CommonConstants } from '../constants/CommonConstants';
import { BottomTabs } from '../components/BottomTabs';
import { BackendService } from '../services/BackendService';
import preferences from '@ohos.data.preferences';

// 默认视频数据（当数据库连接失败时使用）
const DEFAULT_VIDEO_LIST = [
  {
    video_id: 1,
    title: '人参药效视频',
    description: '了解人参的药效与使用方法',
    video_url: $rawfile('videox.mp4'),
    cover_image: CommonConstants.IMAGE_URL_1,
    likes: 120,
    comments: 5,
    views: 1000,
    liked: false,
    collected: false,
  },
  {
    video_id: 2,
    title: '枸杞养生视频',
    description: '枸杞的养生功效与食用技巧',
    video_url: $rawfile('videox.mp4'),
    cover_image: CommonConstants.IMAGE_URL_2,
    likes: 80,
    comments: 3,
    views: 800,
    liked: false,
    collected: false,
  },
  {
    video_id: 3,
    title: '当归补血视频',
    description: '当归的补血作用及注意事项',
    video_url: $rawfile('videox.mp4'),
    cover_image: CommonConstants.IMAGE_URL_3,
    likes: 150,
    comments: 8,
    views: 1200,
    liked: false,
    collected: false,
  },
];

@Entry
@Component
struct VideoPage {
  @State currentVideoIndex: number = 0; // 当前滑动器视频索引
  @State videoList: Array<any> = DEFAULT_VIDEO_LIST; // 视频列表
  @State commentVisibility: { [key: number]: boolean } = {}; // 控制评论区域显示
  @State userId: number = 0; // 用户ID
  @State isLoading: boolean = false; // 加载状态

  aboutToAppear() {
    this.loadUserId();
    this.fetchVideoList();
  }

  onPageShow() {
    this.fetchVideoList();
  }

  // 加载用户ID
  private async loadUserId() {
    try {
      const context = getContext(this);
      const pref = await preferences.getPreferences(context, 'user_token');
      const userIdValue = await pref.get('user_id', 0);
      this.userId = Number(userIdValue);
      console.log('VideoPage: 用户ID:', this.userId);
    } catch (e) {
      console.error('加载用户ID失败:', e);
      this.userId = 0;
    }
  }

  // 获取视频列表
  private async fetchVideoList() {
    this.isLoading = true;
    try {
      console.log('开始获取视频列表...');
      const videos = await BackendService.fetchVideoList(this.userId);
      console.log('API返回原始视频数据:', JSON.stringify(videos));
      // 处理视频数据，确保视频URL可用
      this.videoList = videos.map(video => {
        const validatedUrl = this.validateVideoUrl(video.video_url);
        console.log(`视频ID: ${video.video_id}, 原始URL: ${video.video_url}, 校验后URL:`, validatedUrl);
        return {
          ...video,
          video_url: validatedUrl,
          cover_image: video.cover_image || CommonConstants.IMAGE_URL_1
        };
      });
      console.log('处理后的视频列表:', JSON.stringify(this.videoList));
    } catch (e) {
      console.error('获取视频列表失败，使用默认数据:', e);
      this.videoList = DEFAULT_VIDEO_LIST;
      promptAction.showToast({
        message: '视频加载失败，使用默认数据',
        duration: 2000
      });
    } finally {
      this.isLoading = false;
    }
  }

  // 验证视频URL，如果无效则使用默认视频
  private validateVideoUrl(videoUrl: string): string | Resource {
    console.log('validateVideoUrl 输入:', videoUrl);
    if (!videoUrl || videoUrl.trim() === '') {
      console.log('URL为空，返回本地视频');
      return $rawfile('videox.mp4');
    }
    if (videoUrl.startsWith('$rawfile(') || videoUrl.startsWith('resources://')) {
      console.log('本地资源路径，直接返回:', videoUrl);
      return videoUrl;
    }
    if (videoUrl.startsWith('http')) {
      console.log('网络URL，暂时返回本地视频:', videoUrl);
      return $rawfile('videox.mp4');
    }
    console.log('未知类型，直接返回:', videoUrl);
    return videoUrl;
  }

  // 播放视频
  private playVideo(videoUrl: string, videoId: number) {
    console.info('尝试播放视频:', videoUrl, '视频ID:', videoId);
    
    // 增加播放量
    if (this.userId && videoId) {
      BackendService.addVideoView(videoId, this.userId).catch(e => {
        console.error('增加播放量失败:', e);
      });
    }
    
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
  private async toggleLike(item: any) {
    if (!this.userId) {
      promptAction.showToast({ message: '请先登录' });
      return;
    }

    try {
      await BackendService.toggleVideoLike(item.video_id, !item.liked, this.userId);
      
      // 更新本地状态
      item.likes = item.liked ? item.likes - 1 : item.likes + 1;
      item.liked = !item.liked;
      this.videoList = [...this.videoList];

      promptAction.showToast({
        message: item.liked ? '点赞成功' : '取消点赞',
        duration: 2000
      });
    } catch (e) {
      console.error('点赞操作失败:', e);
      promptAction.showToast({
        message: '操作失败，请稍后再试',
        duration: 2000
      });
    }
  }

  // 切换收藏状态
  private async toggleCollect(item: any) {
    if (!this.userId) {
      promptAction.showToast({ message: '请先登录' });
      return;
    }

    try {
      await BackendService.toggleVideoCollect(item.video_id, !item.collected, this.userId);
      
      // 更新本地状态
      item.collections = item.collected ? item.collections - 1 : item.collections + 1;
      item.collected = !item.collected;
      this.videoList = [...this.videoList];

      promptAction.showToast({
        message: item.collected ? '收藏成功' : '取消收藏',
        duration: 2000
      });
    } catch (e) {
      console.error('收藏操作失败:', e);
      promptAction.showToast({
        message: '操作失败，请稍后再试',
        duration: 2000
      });
    }
  }

  // 打开评论输入页面
  private openCommentDialog(videoId: number) {
    if (!this.userId) {
      promptAction.showToast({ message: '请先登录' });
      return;
    }
    
    router.pushUrl({
      url: 'pages/CommentInputPage',
      params: { videoId },
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
            Image(item.cover_image)
              .width('100%')
              .height(150)
              .objectFit(ImageFit.Cover)
              .borderRadius(8)
              .onClick(() => this.playVideo(item.video_url, item.video_id))
          }
          .width('100%')
        }, item => item.video_id.toString())
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
            .margin({ top: 20, bottom: 20 })
          } else {
            ForEach(this.videoList, (item) => {
              Column() {
                // 视频项
                Row() {
                  // 缩略图
                  Image(item.cover_image)
                    .width(100)
                    .height(100)
                    .objectFit(ImageFit.Cover)
                    .borderRadius(8)
                    .margin({ right: 10 })
                    .onClick(() => this.playVideo(item.video_url, item.video_id))

                  // 内容
                  Column() {
                    Text(item.title)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .width('100%')
                      .textAlign(TextAlign.Start)
                      .margin({ bottom: 8 })

                    Text(item.description)
                      .fontSize(12)
                      .fontColor('#666666')
                      .width('100%')
                      .textAlign(TextAlign.Start)
                      .margin({ bottom: 8 })
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Row() {
                      Button() {
                        Text(item.liked ? '取消' : '点赞')
                          .fontSize(12)
                      }
                      .width(50)
                      .height(25)
                      .backgroundColor(item.liked ? '#FF9999' : '#007AFF')
                      .margin({ right: 5 })
                      .onClick(() => this.toggleLike(item))

                      Button() {
                        Text(item.collected ? '取消收藏' : '收藏')
                          .fontSize(12)
                      }
                      .width(50)
                      .height(25)
                      .backgroundColor(item.collected ? '#FF9999' : '#007AFF')
                      .margin({ right: 5 })
                      .onClick(() => this.toggleCollect(item))

                      Button() {
                        Text('评论')
                          .fontSize(12)
                      }
                      .width(50)
                      .height(25)
                      .backgroundColor('#007AFF')
                      .onClick(() => this.openCommentDialog(item.video_id))
                    }
                    .width('100%')
                    .margin({ bottom: 8 })
                  }
                  .width('40%')
                  .height(100)
                  .justifyContent(FlexAlign.Start)

                  // 统计信息
                  Column() {
                    Text(`点赞量${item.likes} `)
                      .fontSize(12)
                      .margin({ bottom: 4 })
                    Text(`收藏量${item.collections || 0} `)
                      .fontSize(12)
                      .margin({ bottom: 4 })
                    Text(`评论量${item.comments || 0} `)
                      .fontSize(12)
                      .margin({ bottom: 4 })
                    Text(`播放量${item.views || 0} `)
                      .fontSize(12)
                  }
                  .width('30%')
                  .height(100)
                  .justifyContent(FlexAlign.End)
                  .alignItems(HorizontalAlign.End)
                }
                .width('100%')
                .padding(10)
                .backgroundColor('#F5F5F5')
                .borderRadius(12)

              // 评论区域（暂时隐藏，因为现在使用数据库评论）
              // Column() {
              //   Row() {
              //     Text(this.commentVisibility[item.video_id] ? '隐藏评论' : '显示评论')
              //       .fontSize(12)
              //       .padding(5)
              //       .onClick(() => this.toggleCommentVisibility(item.video_id))
              //   }
              //   .width('100%')
              //   .backgroundColor('#E0E0E0')
              //   .borderRadius(4)
              // }
              // .width('100%')
              // .padding({ left: 10, right: 10, bottom: 10 })
            }
            .width('100%')
            .margin({ bottom: 10 })
          }, item => item.video_id.toString())
          }
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