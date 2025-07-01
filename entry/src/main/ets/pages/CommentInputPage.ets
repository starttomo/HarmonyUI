import router from '@ohos.router';
import prompt from '@system.prompt';
import { VIDEO_LIST } from './VideoPage';

@Entry
@Component
struct CommentInputPage {
  @State commentInput: string = '';
  @State itemId: number = 0;

  aboutToAppear() {
    // Retrieve itemId with type assertion
    const params = router.getParams() as { itemId?: number };
    if (params && typeof params.itemId === 'number') {
      this.itemId = params.itemId;
    } else {
      prompt.showToast({ message: '无效的视频ID' });
      router.back();
    }
  }

  private saveComment() {
    if (!this.commentInput.trim()) {
      prompt.showToast({ message: '评论不能为空' });
      return;
    }

    let videoItem = VIDEO_LIST.find(item => item.id === this.itemId);
    if (videoItem) {
      videoItem.comments.push(this.commentInput);
      prompt.showToast({ message: '评论提交成功' });
      router.back();
    } else {
      prompt.showToast({ message: '视频不存在' });
      router.back();
    }
  }

  build() {
    Column() {
      Text('添加评论')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ left: 10, top: 10, bottom: 10 })

      TextInput({ placeholder: '请输入你的评论' })
        .width('90%')
        .height(100)
        .fontSize(14)
        .margin({ bottom: 20 })
        .padding(10)
        .borderRadius(8)
        .backgroundColor('#F5F5F5')
        .onChange((value: string) => {
          this.commentInput = value;
        })

      Row() {
        Button() {
          Text('取消')
            .fontSize(16)
        }
        .width(100)
        .height(40)
        .margin({ right: 10 })
        .backgroundColor('#666666')
        .onClick(() => router.back())

        Button() {
          Text('提交')
            .fontSize(16)
        }
        .width(100)
        .height(40)
        .backgroundColor('#007AFF')
        .onClick(() => this.saveComment())
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}