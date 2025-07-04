import router from '@ohos.router';
import prompt from '@system.prompt';
import { BackendService } from '../services/BackendService';
import preferences from '@ohos.data.preferences';

@Entry
@Component
struct CommentInputPage {
  @State commentInput: string = '';
  @State videoId: number = 0;
  @State userId: number = 0;
  @State isLoading: boolean = false;

  aboutToAppear() {
    this.loadUserId();
    // Retrieve videoId with type assertion
    const params = router.getParams() as { videoId?: number };
    if (params && typeof params.videoId === 'number') {
      this.videoId = params.videoId;
      console.log('CommentInputPage: 视频ID:', this.videoId);
    } else {
      prompt.showToast({ message: '无效的视频ID' });
      router.back();
    }
  }

  // 加载用户ID
  private async loadUserId() {
    try {
      const context = getContext(this);
      const pref = await preferences.getPreferences(context, 'user_token');
      const userIdValue = await pref.get('user_id', 0);
      this.userId = Number(userIdValue);
      console.log('CommentInputPage: 用户ID:', this.userId);
    } catch (e) {
      console.error('加载用户ID失败:', e);
      this.userId = 0;
    }
  }

  private async saveComment() {
    if (!this.commentInput.trim()) {
      prompt.showToast({ message: '评论不能为空' });
      return;
    }

    if (!this.userId) {
      prompt.showToast({ message: '请先登录' });
      return;
    }

    this.isLoading = true;
    try {
      await BackendService.addVideoComment(this.videoId, this.commentInput, this.userId);
      prompt.showToast({ message: '评论提交成功' });
      router.back();
    } catch (e) {
      console.error('提交评论失败:', e);
      prompt.showToast({ message: '评论提交失败，请稍后再试' });
    } finally {
      this.isLoading = false;
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
          Text(this.isLoading ? '提交中...' : '提交')
            .fontSize(16)
        }
        .width(100)
        .height(40)
        .backgroundColor('#007AFF')
        .enabled(!this.isLoading)
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