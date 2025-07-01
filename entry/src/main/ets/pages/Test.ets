import promptAction from '@ohos.promptAction';

@Entry
@Component
struct TestVideoPlayerPage {
  private videoController: VideoController = new VideoController();
  private videoUrl: 'resources://rawfile/videox.mp4'; // 本地视频文件路径

  build() {
    Column() {
      Text('测试视频播放')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })

      Video({
        src: this.videoUrl,
        controller: this.videoController
      })
        .width('100%')
        .height(300)
        .controls(true) // 启用内置控件，允许用户手动调整进度
        .autoPlay(true)
        .onPrepared(() => {
          console.info('视频准备就绪');
          this.videoController.start(); // 确保视频开始播放
          promptAction.showToast({
            message: '视频准备就绪',
            duration: 2000
          });
        })
        .onError(() => {
          console.error('视频播放错误:', JSON.stringify('err'));
          promptAction.showToast({
            message: '视频播放失败: ' + JSON.stringify('err'),
            duration: 3000
          });
        })

      Button('重新播放')
        .width(100)
        .height(40)
        .backgroundColor('#007AFF')
        .margin({ top: 20 })
        .onClick(() => {
          // 停止并重新播放视频
          this.videoController.stop();
          this.videoController.start();
          promptAction.showToast({
            message: '重新播放视频',
            duration: 2000
          });
        })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
  }
}