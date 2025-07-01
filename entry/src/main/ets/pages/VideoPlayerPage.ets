import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
@Entry
@Component
struct VideoPlayerPage {
  @State videoUrl: string = '';
  private videoController: VideoController = new VideoController();

  aboutToAppear() {
    const params = router.getParams();
    if (params?.['videoUrl']) {
      this.videoUrl = params['videoUrl']
      console.info('视频源:', this.videoUrl);
    }
  }

  build() {
    Column() {
      // 返回按钮
      Button('返回')
        .onClick(() => router.back())

      // 视频容器
      if (this.videoUrl) {
        Video({
          src: this.videoUrl,
          controller: this.videoController
        })
          .controls(true)
          .autoPlay(true)
          .width('100%')
          .height(500)
          .onPrepared(() => {
            console.info('视频准备就绪');
            this.videoController.start(); // Explicitly start playback
          })
          .onError(() => {
            console.error('播放错误:', JSON.stringify('err')); // Log actual error
            promptAction.showToast({
              message: '视频播放失败: ' + JSON.stringify('err'),
              duration: 3000
            });
          })
      } else {
        Text('无效视频地址')
          .fontColor('#ff0000')
      }
    }
    .width('100%')
    .padding(20)
  }
}